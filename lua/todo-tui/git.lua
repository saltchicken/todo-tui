local git = {}

local Job = require("plenary.job")

git.current_revision = nil

git.setup = function(opts, Windows)
	git.repo_path = opts.repo_path

	git.add = Job:new({
		command = "git",
		args = { "add", "." },
		cwd = git.repo_path, -- Set this to the appropriate repo path
		on_start = function()
			print("Running git add...")
		end,
		on_stdout = function(_, data)
			print("stdout:", data)
		end,
		on_stderr = function(_, data)
			print("stderr:", data)
		end,
		on_exit = function(_, return_val)
			if return_val == 0 then
				print("Git add successful!")
			else
				print("Git add failed!")
			end
		end,
	})

	git.commit = Job:new({
		command = "git",
		args = { "commit", "-m", "Update" }, --TODO: Change hardcorded commit message
		cwd = git.repo_path, -- Set this to the appropriate repo path
		on_start = function()
			print("Running git commit...")
		end,
		on_stdout = function(_, data)
			print("stdout:", data)
		end,
		on_stderr = function(_, data)
			print("stderr:", data)
		end,
		on_exit = function(_, return_val)
			if return_val == 0 then
				print("Git commit successful!")
			else
				print("Git commit failed!")
			end
		end,
	})

	git.push = Job:new({
		command = "git",
		args = { "push" },
		cwd = git.repo_path, -- Set this to the appropriate repo path
		on_start = function()
			print("Pushing to git...")
		end,
		on_stdout = function(_, data)
			print("stdout:", data)
		end,
		on_stderr = function(_, data)
			print("stderr:", data)
		end,
		on_exit = function(_, return_val)
			if return_val == 0 then
				print("Git push successful!")
			else
				print("Git push failed!")
			end
		end,
	})
	git.fetch = Job:new({
		command = "git",
		args = { "fetch" },
		cwd = git.repo_path,
		on_exit = function(_, return_val)
			if return_val == 0 then
				print("Fetch successful")
			else
				print("Failed to fetch")
			end
		end,
	})
	git.status = Job:new({
		command = "git",
		args = { "status", "--branch", "--porcelain" },
		cwd = git.repo_path,
		on_exit = function(job, return_val)
			if return_val == 0 then
				local result = table.concat(job:result(), "\n")
				print(result)
				if result:match("behind") then
					vim.schedule_wrap(function()
						Windows:yes_no_prompt("Update available", function()
							git.pull:start()
						end, nil)
					end)()
				else
					print("Up to date")
				end
			else
				print(table.concat(job:result(), "\n"))
				print("Error running git status")
			end
		end,
	})

	git.check_update_available = function()
		git.fetch:after(function()
			git.status:start()
		end)
		git.fetch:start()
	end

	git.pull = Job:new({
		command = "git",
		args = { "pull" },
		cwd = git.repo_path,
		on_exit = function(j, return_val)
			if return_val == 0 then
				print("Git folder updated successfully!")
			else
				print("Failed to update git folder.")
			end
		end,
	})
end

git.add_commit_push = function()
	git.commit:after(function()
		git.push:start()
	end)
	git.add:after(function()
		git.commit:start()
	end)
	git.add:start()
end

--
-- git.get_current_revision = Job:new({
-- 	command = "git",
-- 	args = { "rev-parse", "HEAD" },
-- 	cwd = git.repo_path,
-- 	on_exit = function(job, return_val)
-- 		if return_val == 0 then
-- 			local commit_hash = table.concat(job:result(), "\n")
-- 			git.current_revision = commit_hash
-- 		else
-- 			print("Failed to get the current revision")
-- 		end
-- 	end,
-- })
--
-- git.compare_local_to_remote = Job:new({
-- 	command = "git",
-- 	args = { "ls-remote", "origin", "HEAD" },
-- 	cwd = git.repo_path,
-- 	on_exit = function(job, return_val)
-- 		if return_val == 0 then
-- 			local result = table.concat(job:result(), "\n")
-- 			print(result)
-- 			local remote_commit_hash = result:match("^(.*)\t") or result
-- 			print("Local: " .. git.current_revision)
-- 			print("Remote: " .. remote_commit_hash)
-- 			if remote_commit_hash == git.current_revision then
-- 				print("Up to date")
-- 			else
-- 				print("Update available")
-- 			end
-- 		else
-- 			print("Failed to get the remote revision")
-- 		end
-- 	end,
-- })
--
-- git.check_update_available = function()
-- 	git.fetch:after(function()
-- 		git.get_current_revision:start()
-- 	end)
-- 	git.get_current_revision:after(function()
-- 		git.compare_local_to_remote:start()
-- 	end)
-- 	git.fetch:start()
-- end
--

git.blocking_pull = function()
	local current_directory
	vim.fn.chdir(git.repo_path)
	vim.fn.system("git pull")
	vim.fn.chdir(current_directory)
end

return git
