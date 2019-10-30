# Generated by Django 2.2.6 on 2019-10-25 04:47

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [("patchwork", "0036_project_commit_url_format")]

    operations = [
        migrations.CreateModel(
            name="BridgedSubmission",
            fields=[
                (
                    "submission",
                    models.OneToOneField(
                        on_delete=django.db.models.deletion.CASCADE,
                        primary_key=True,
                        serialize=False,
                        to="patchwork.Submission",
                    ),
                ),
                ("merge_request", models.IntegerField()),
                (
                    "commit",
                    models.CharField(
                        blank=True, max_length=128, null=True, unique=True
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="GitForge",
            fields=[
                (
                    "project",
                    models.OneToOneField(
                        on_delete=django.db.models.deletion.CASCADE,
                        primary_key=True,
                        serialize=False,
                        to="patchwork.Project",
                    ),
                ),
                ("host", models.CharField(max_length=255)),
                ("forge_id", models.IntegerField()),
                ("subject_prefix", models.CharField(max_length=64)),
            ],
            options={"unique_together": {("host", "forge_id")}},
        ),
    ]