Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbbAVUei (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:38 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/38] iwlwifi: mvm: BT Coex - set all the co-running values to 0
Date: Thu, 22 Jan 2015 22:33:22 +0200
Message-Id: <1421958809-3371-31-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214447_357596_497040BC)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this value, we de-facto disable the feature. Since it
is not working yet, disable it completely.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 16 ++++++++--------
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index d2fd48c..1ec4d55 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -342,7 +342,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 12,
 		.lut20 = {
-			cpu_to_le32(0x00000001),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -363,7 +363,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 20,
 		.lut20 = {
-			cpu_to_le32(0x00000002),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -384,7 +384,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 21,
 		.lut20 = {
-			cpu_to_le32(0x00000003),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -405,7 +405,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 23,
 		.lut20 = {
-			cpu_to_le32(0x00000004),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -426,7 +426,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 27,
 		.lut20 = {
-			cpu_to_le32(0x00000005),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -447,7 +447,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 30,
 		.lut20 = {
-			cpu_to_le32(0x00000006),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -468,7 +468,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 32,
 		.lut20 = {
-			cpu_to_le32(0x00000007),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -489,7 +489,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 33,
 		.lut20 = {
-			cpu_to_le32(0x00000008),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index 973f288..d530ef3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -330,7 +330,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 12,
 		.lut20 = {
-			cpu_to_le32(0x00000001),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -351,7 +351,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 20,
 		.lut20 = {
-			cpu_to_le32(0x00000002),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -372,7 +372,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 21,
 		.lut20 = {
-			cpu_to_le32(0x00000003),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -393,7 +393,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 23,
 		.lut20 = {
-			cpu_to_le32(0x00000004),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -414,7 +414,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 27,
 		.lut20 = {
-			cpu_to_le32(0x00000005),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -435,7 +435,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 30,
 		.lut20 = {
-			cpu_to_le32(0x00000006),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -456,7 +456,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 32,
 		.lut20 = {
-			cpu_to_le32(0x00000007),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
@@ -477,7 +477,7 @@ static const struct corunning_block_luts antenna_coupling_ranges[] = {
 	{
 		.range = 33,
 		.lut20 = {
-			cpu_to_le32(0x00000008),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
 			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-- 
1.9.1

