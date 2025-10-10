# Python Django Example - Mini-CoderBrain

Example Django REST API with Mini-CoderBrain integration.

## 🚀 Quick Start

```bash
# From mini-coder-brain root:
./install.sh examples/python-django

# Open in Claude Code:
cd examples/python-django
```

## 📋 What's Demonstrated

- ✅ **Auto-Detection**: Backend structure (models/, views/, api/)
- ✅ **Database Awareness**: Model schema mapping
- ✅ **API Mapping**: REST endpoint structure
- ✅ **Admin Integration**: Django admin interface
- ✅ **Migration Tracking**: Database migration history

## 🎯 Features to Try

### 1. Model Development
Ask Claude:
- "Create a new User model with authentication"
- "Add a many-to-many relationship between Post and Tag"
- "Generate a migration for the Product model"

### 2. API Development
Ask Claude:
- "Build a REST API for the Blog model"
- "Add pagination to the list endpoint"
- "Implement JWT authentication"

### 3. Database Navigation
Use commands:
```
/map-database --rebuild
/map-codebase          # View all models and endpoints
```

## 📊 Expected Performance

- **Context Loading**: < 1 second
- **Conversation Length**: 100+ turns without errors
- **Database Awareness**: Full schema understanding

## 🧪 Testing Mini-CoderBrain

1. Start conversation
2. Ask about database schema
3. Request API endpoint creation
4. Verify context persists across all tasks

## 📂 Project Structure

```
python-django/
├── .claude/              # Mini-CoderBrain (installed via install.sh)
├── CLAUDE.md            # Controller (installed via install.sh)
├── myproject/
│   ├── settings.py
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
├── myapp/
│   ├── models.py
│   ├── views.py
│   ├── serializers.py
│   ├── urls.py
│   ├── admin.py
│   └── tests.py
├── migrations/
│   └── 0001_initial.py
├── manage.py
└── requirements.txt
```

## 📝 Note

This is a placeholder example structure.

For a full working example:
1. Create Django project: `django-admin startproject myproject`
2. Create app: `python manage.py startapp myapp`
3. Install Mini-CoderBrain: `./install.sh path/to/myproject`
4. Experience the difference!
