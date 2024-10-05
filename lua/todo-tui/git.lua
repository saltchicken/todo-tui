local git = {}

local Job = require("plenary.job")

git.repo_path = "/home/saltchicken/.local/share/keep"

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

git.add = function()
	Job:new({
		command = "git",
		args = { "add", "." },
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
	}):start()
end

git.commit = function()
	local commit_message = "Update"
	Job:new({
		command = "git",
		args = { "commit", "-m", commit_message },
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
	}):start()
end

git.push = function()
	Job:new({
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
	}):start()
end

return git
