# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


resource "google_monitoring_notification_channel" "pubsub" {
  display_name = "Alert notifications"
  type         = "pubsub"
  labels       = {
    "topic" = "projects/${var.project}/topics/tf-topic"
  }
}

resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "My Metric Alert Policy"
  combiner     = "OR"
  conditions {
    display_name = "test condition"
    condition_threshold {
      filter     = "metric.type=\"custom.googleapis.com/testing_metric\" AND resource.type=\"gce_instance\""
      duration   = "0s"
      comparison = "COMPARISON_GT"
      threshold_value = "3"
    }
  }
  notification_channels = ["${google_monitoring_notification_channel.pubsub.channel_id}"]
}