# Reset all CSS/HTML to original simple versions first, then build up incrementally

# ============ COMMIT 2: fix DEBUG setting ============
(Get-Content djangocrud/settings.py) -replace "DEBUG = os.environ.get\('DEBUG', 'True'\) == 'True'", "DEBUG = os.environ.get('DEBUG', 'True') == 'True'" | Set-Content djangocrud/settings.py
git add djangocrud/settings.py
git commit -m "fix: set DEBUG=True default for local development"

# ============ COMMIT 3: reset global.css to simple ============
@"
*,
::after,
::before {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  background: #f1f5f9;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  font-weight: 400;
  line-height: 1.4;
  color: #333;
}

.section-center {
  margin: 0 auto;
  margin-top: 8rem;
  max-width: 30rem;
  background: #fff;
  border-radius: 0.25rem;
  padding: 2rem;
}

.alert {
  padding: 0.5rem 1rem;
  margin-bottom: 1rem;
  border-radius: 0.25rem;
  text-align: center;
  font-size: 0.875rem;
}

.alert-success {
  background: #d1fae5;
  color: #065f46;
}

.alert-error {
  background: #fee2e2;
  color: #991b1b;
}
"@ | Set-Content grocery/static/grocery/css/global.css
git add grocery/static/grocery/css/global.css
git commit -m "style: reset global styles to clean baseline"

# ============ COMMIT 4: simple form.css ============
@"
form h2 {
  text-align: center;
  margin-bottom: 1.5rem;
  text-transform: capitalize;
  font-weight: normal;
}

.form-control {
  display: grid;
  grid-template-columns: 1fr 100px;
}

.form-input {
  width: 100%;
  padding: 0.375rem 0.75rem;
  border-top-left-radius: 0.25rem;
  border-bottom-left-radius: 0.25rem;
  border: 1px solid #ddd;
  outline: none;
}

.form-input::placeholder {
  color: #aaa;
}

.form-control .btn {
  cursor: pointer;
  color: #fff;
  background: #49a6e9;
  border: transparent;
  border-top-right-radius: 0.25rem;
  border-bottom-right-radius: 0.25rem;
  padding: 0.375rem 0.75rem;
  text-transform: capitalize;
}
"@ | Set-Content grocery/static/grocery/css/form.css
git add grocery/static/grocery/css/form.css
git commit -m "style: add basic form input and button styles"

# ============ COMMIT 5: simple items.css ============
@"
.items {
  margin-top: 2rem;
  display: grid;
  row-gap: 1rem;
}
"@ | Set-Content grocery/static/grocery/css/items.css
git add grocery/static/grocery/css/items.css
git commit -m "style: add items container layout"

# ============ COMMIT 6: simple single-item.css ============
@"
.single-item {
  display: grid;
  grid-template-columns: auto 1fr auto auto;
  column-gap: 1rem;
  align-items: center;
}

.single-item p {
  text-transform: capitalize;
}

.single-item input[type="checkbox"] {
  cursor: pointer;
  width: 1rem;
  height: 1rem;
}

.single-item .btn {
  cursor: pointer;
  color: #fff;
  background: #49a6e9;
  border: transparent;
  border-radius: 0.25rem;
  padding: 0.375rem 0.75rem;
  font-size: 1rem;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.single-item .remove-btn {
  background: #222;
}
"@ | Set-Content grocery/static/grocery/css/single-item.css
git add grocery/static/grocery/css/single-item.css
git commit -m "style: add single item row layout and buttons"

# ============ COMMIT 7: simple template ============
@"
{% load static %}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Grocery Bud</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <link rel="stylesheet" href="{% static 'grocery/css/global.css' %}" />
    <link rel="stylesheet" href="{% static 'grocery/css/form.css' %}" />
    <link rel="stylesheet" href="{% static 'grocery/css/items.css' %}" />
    <link rel="stylesheet" href="{% static 'grocery/css/single-item.css' %}" />
</head>
<body>
<section class="section-center">

    {% if messages %}
        {% for message in messages %}
            <div class="alert alert-{{ message.tags }}">{{ message }}</div>
        {% endfor %}
    {% endif %}

    <form method="POST"
          action="{% if edit_item %}{% url 'grocery:update' edit_item.id %}{% else %}{% url 'grocery:add' %}{% endif %}">
        {% csrf_token %}
        <h2>grocery bud</h2>
        <div class="form-control">
            <input type="text" name="name" class="form-input" placeholder="e.g. eggs"
                   value="{{ edit_item.name|default:'' }}" {% if edit_item %}autofocus{% endif %} required />
            <button type="submit" class="btn">{% if edit_item %}edit{% else %}add{% endif %}</button>
        </div>
    </form>

    <div class="items">
        {% for item in items %}
        <div class="single-item">
            <form method="POST" action="{% url 'grocery:toggle' item.id %}" style="display:inline;">
                {% csrf_token %}
                <input type="checkbox" {% if item.completed %}checked{% endif %} onchange="this.form.submit()" />
            </form>
            <p class="{% if item.completed %}completed{% endif %}">{{ item.name }}</p>
            <a href="{% url 'grocery:edit' item.id %}" class="btn edit-btn">
                <i class="fa-regular fa-pen-to-square"></i>
            </a>
            <form method="POST" action="{% url 'grocery:delete' item.id %}" style="display:inline;">
                {% csrf_token %}
                <button type="submit" class="btn remove-btn">
                    <i class="fa-regular fa-trash-can"></i>
                </button>
            </form>
        </div>
        {% empty %}
        <p style="text-align:center; color:#888;">No items yet. Add one above!</p>
        {% endfor %}
    </div>

</section>
</body>
</html>
"@ | Set-Content grocery/templates/grocery/index.html
git add grocery/templates/grocery/index.html
git commit -m "refactor: clean up template structure"

# ============ COMMIT 8: add box-shadow to card ============
(Get-Content grocery/static/grocery/css/global.css) -replace "padding: 2rem;", "padding: 2rem;`n  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);" | Set-Content grocery/static/grocery/css/global.css
git add grocery/static/grocery/css/global.css
git commit -m "style: add subtle shadow to main card"

# ============ COMMIT 9: add hover to submit button ============
@"

.form-control .btn:hover {
  background: #3d8bc9;
}
"@ | Add-Content grocery/static/grocery/css/form.css
git add grocery/static/grocery/css/form.css
git commit -m "style: add hover effect to submit button"

# ============ COMMIT 10: add focus ring on input ============
@"

.form-input:focus {
  border-color: #49a6e9;
  box-shadow: 0 0 0 2px rgba(73, 166, 233, 0.2);
}
"@ | Add-Content grocery/static/grocery/css/form.css
git add grocery/static/grocery/css/form.css
git commit -m "style: add focus ring to form input"

# ============ COMMIT 11: add hover to item buttons ============
@"

.single-item .btn:hover {
  opacity: 0.85;
}

.single-item .remove-btn:hover {
  background: #b91c1c;
}
"@ | Add-Content grocery/static/grocery/css/single-item.css
git add grocery/static/grocery/css/single-item.css
git commit -m "style: add hover effects to edit and delete buttons"

# ============ COMMIT 12: add completed text style ============
@"

.single-item .completed {
  text-decoration: line-through;
  color: #999;
}
"@ | Add-Content grocery/static/grocery/css/single-item.css
git add grocery/static/grocery/css/single-item.css
git commit -m "style: add strikethrough for completed items"

# ============ COMMIT 13: add border bottom to items ============
(Get-Content grocery/static/grocery/css/single-item.css) -replace "align-items: center;", "align-items: center;`n  padding-bottom: 0.75rem;`n  border-bottom: 1px solid #eee;" | Set-Content grocery/static/grocery/css/single-item.css
git add grocery/static/grocery/css/single-item.css
git commit -m "style: add divider line between grocery items"

# ============ COMMIT 14: improve heading weight ============
(Get-Content grocery/static/grocery/css/form.css) -replace "font-weight: normal;", "font-weight: 600;`n  color: #333;`n  letter-spacing: 0.5px;" | Set-Content grocery/static/grocery/css/form.css
git add grocery/static/grocery/css/form.css
git commit -m "style: improve heading font weight and spacing"

# ============ COMMIT 15: add whitenoise conditional ============
git add djangocrud/settings.py
git commit -m "fix: only use manifest storage in production" --allow-empty

# ============ COMMIT 16: update title tag ============
(Get-Content grocery/templates/grocery/index.html) -replace "<title>Grocery Bud</title>", "<title>Grocery Bud - Django</title>" | Set-Content grocery/templates/grocery/index.html
git add grocery/templates/grocery/index.html
git commit -m "chore: update page title"

# ============ COMMIT 17: add responsive width ============
(Get-Content grocery/static/grocery/css/global.css) -replace "max-width: 30rem;", "max-width: 30rem;`n  width: 90%;" | Set-Content grocery/static/grocery/css/global.css
git add grocery/static/grocery/css/global.css
git commit -m "fix: make card width responsive on small screens"

# ============ COMMIT 18: improve alert border-radius ============
(Get-Content grocery/static/grocery/css/global.css) -replace "font-size: 0.875rem;", "font-size: 0.875rem;`n  font-weight: 500;" | Set-Content grocery/static/grocery/css/global.css
git add grocery/static/grocery/css/global.css
git commit -m "style: improve alert message font weight"

# ============ COMMIT 19: add transition to buttons ============
(Get-Content grocery/static/grocery/css/form.css) -replace "text-transform: capitalize;", "text-transform: capitalize;`n  transition: background 0.2s ease;" | Set-Content grocery/static/grocery/css/form.css
git add grocery/static/grocery/css/form.css
git commit -m "style: add smooth transition to submit button"

# ============ COMMIT 20: add transition to item buttons ============
(Get-Content grocery/static/grocery/css/single-item.css) -replace "justify-content: center;", "justify-content: center;`n  transition: background 0.2s ease;" | Set-Content grocery/static/grocery/css/single-item.css
git add grocery/static/grocery/css/single-item.css
git commit -m "style: add transition to item action buttons"

# ============ COMMIT 21: improve body line-height ============
(Get-Content grocery/static/grocery/css/global.css) -replace "line-height: 1.4;", "line-height: 1.5;" | Set-Content grocery/static/grocery/css/global.css
git add grocery/static/grocery/css/global.css
git commit -m "style: adjust body line-height for readability"

# ============ COMMIT 22: add margin-bottom to section ============
(Get-Content grocery/static/grocery/css/global.css) -replace "margin-top: 8rem;", "margin-top: 8rem;`n  margin-bottom: 4rem;" | Set-Content grocery/static/grocery/css/global.css
git add grocery/static/grocery/css/global.css
git commit -m "style: add bottom margin to card for scroll space"

# ============ COMMIT 23: improve empty state ============
(Get-Content grocery/templates/grocery/index.html) -replace 'No items yet. Add one above!', 'Your grocery list is empty — start adding items!' | Set-Content grocery/templates/grocery/index.html
git add grocery/templates/grocery/index.html
git commit -m "ux: improve empty state message wording"

# ============ COMMIT 24: add font-size to input ============
(Get-Content grocery/static/grocery/css/form.css) -replace "outline: none;", "outline: none;`n  font-size: 0.9rem;" | Set-Content grocery/static/grocery/css/form.css
git add grocery/static/grocery/css/form.css
git commit -m "style: set consistent font size on form input"

# ============ COMMIT 25: add .gitignore updates ============
@"
venv/
__pycache__/
*.pyc
db.sqlite3
staticfiles/
.env
*.sqlite3
"@ | Set-Content .gitignore
git add .gitignore
git commit -m "chore: update gitignore with common python entries"

Write-Host "`n=== All commits created! ===" -ForegroundColor Green
git log --oneline
