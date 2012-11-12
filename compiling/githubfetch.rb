require "github_api"
require "date"

class GithubFetch
  def initialize(user, repo)
    @user = user
    @repo = repo
    @github = Github::Repos.new :user => user
  end
  def commits
    @commits ||= @github.commits.all @user, @repo
  end

  def get_latest_date_for_repo
    latest_commit.sha = self.commits.first.sha
    date = latest_commit.commit.author.date
    DateTime.parse(date)
  end

  def get_individual_commit(sha)
    puts "hitting Github"
    @github.commits.get @user, @repo, sha
  end

  def get_latest_date_for_folder(folder)
    foundDate = false
    puts "hitting Github"
    self.commits.each { |c|
      puts "hitting Github"
      commit = get_individual_commit(c.sha)
      commit.files.each { |cf|
        filename = cf.filename
        if filename.include?(folder)
          return DateTime.parse(commit.date)
        end
      }
    }
  end
end


