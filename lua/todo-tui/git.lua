local git = {}

local Job = require("plenary.job")

git.setup = function(opts)
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
end

git.pull = function()
	Job:new({
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
	}):start()
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

return git
