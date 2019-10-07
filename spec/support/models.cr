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
      id: 1,
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
      id: 2,
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
