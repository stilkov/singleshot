# Singleshot  Copyright (C) 2008-2009  Intalio, Inc
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


class GraphsController < ApplicationController #:nodoc:
  def show
    today, days = Date.today, 21.days
    completed = authenticated.tasks.completed.in_the_past(days)
    grouped = completed.group_by { |t| t.updated_at.to_date }
    @completed = (today - days + 1..today).map { |date| tasks = grouped[date] ; [date, tasks ? tasks.size : 0] }

    slices = 20
    timed = completed.map { |task| [(task.updated_at - task.created_at) / 1.hours, task] }
    slice = (timed.map { |hours, task| hours }.max.to_f / slices).ceil
    grouped = timed.group_by { |hours, task| logger.info hours ; (hours / slice).floor }
    @completed_in = (1..slices).map { |i| tasks = grouped[i - 1] ; [i * slice, tasks ? tasks.size : 0] }
  end
end
