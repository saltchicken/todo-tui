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

local add = Job:new({
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

local commit = Job:new({
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

local push = Job:new({
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

git.add_commit_push = function()
	commit:after(function()
		push:start()
	end)
	add:after(function()
		commit:start()
	end)
	add:start()
end

return git
