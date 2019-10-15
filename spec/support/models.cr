def clear(model, skip = false)
  model.adapter.open do |db|
    db.exec "TRUNCATE TABLE #{model.table_name} RESTART IDENTITY"
  end unless skip
  yield
  model.adapter.open do |db|
    db.exec "TRUNCATE TABLE #{model.table_name} RESTART IDENTITY"
  end unless skip
end

def with_manager(skip_clear = false)
  clear User, skip_clear do
    User.create(
      fb_id: "manager",
      name: "Manager",
      email: "manager@bar.com",
      position_number: 1
    )
    yield
  end
end

def with_member(skip_clear = false)
  clear User, skip_clear do
    User.create(
      fb_id: "member",
      name: "Member",
      email: "member@foo.com",
      position_number: 0
    )
    yield
  end
end

def with_users
  with_manager do
    with_member(true) do
      yield
    end
  end
end

def with_approved_runner
  clear Runner do
    with_users do
      Runner.create(
        user_id: 2_i64,
        name: "runner",
        birthday: (Time.local - 20.years).at_beginning_of_day,
        phone: "0912345678",
        organization: "org",
        status_number: 1,
        approved_at: Time.local,
        approver_id: 1_i64
      )
      yield
    end
  end
end

def with_pending_runner
  clear Runner do
    with_users do
      Runner.create(
        user_id: 2_i64,
        name: "runner",
        birthday: (Time.local - 20.years).at_beginning_of_day,
        phone: "0912345678",
        organization: "org"
      )
      yield
    end
  end
end

def with_rejected_runner
  clear Runner do
    clear RunnerError do
      with_users do
        Runner.create(
          user_id: 2_i64,
          name: "runner",
          birthday: (Time.local - 20.years).at_beginning_of_day,
          phone: "0912345678",
          organization: "org",
          status_number: 2,
          approver_id: 1_i64
        )
        RunnerError.create(
          runner_id: 1_i64,
          description: "desc"
        )
        yield
      end
    end
  end
end

def with_event
  clear Event do
    Event.create(
      name: "name",
      organizer: "organizer",
      location: "somewhere",
      level_number: 6,
      region_number: 1,
      start_at: Time.local + 1.month,
      iaaf: true,
      aims: false,
      measured: false,
      recordable: true
    )
    yield
  end
end

def with_distance
  clear Distance do
    with_event do
      Distance.create(
        name: "name",
        event_id: 1_i64
      )
      yield
    end
  end
end
