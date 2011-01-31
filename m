Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510Ab1AaVxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:53:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/11] iwlagn: adjust rate table
Date: Mon, 31 Jan 2011 13:40:38 -0800
Message-Id: <1296510047-24576-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Minor adjustment for rate scale table

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 75fcd30..20d01a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -179,31 +179,31 @@ static s32 expected_tpt_legacy[IWL_RATE_COUNT] = {
 };
 
 static s32 expected_tpt_siso20MHz[4][IWL_RATE_COUNT] = {
-	{0, 0, 0, 0, 42, 0,  76, 102, 124, 158, 183, 193, 202}, /* Norm */
-	{0, 0, 0, 0, 46, 0,  82, 110, 132, 167, 192, 202, 210}, /* SGI */
-	{0, 0, 0, 0, 48, 0,  93, 135, 176, 251, 319, 351, 381}, /* AGG */
-	{0, 0, 0, 0, 53, 0, 102, 149, 193, 275, 348, 381, 413}, /* AGG+SGI */
+	{0, 0, 0, 0, 42, 0,  76, 102, 124, 159, 183, 193, 202}, /* Norm */
+	{0, 0, 0, 0, 46, 0,  82, 110, 132, 168, 192, 202, 210}, /* SGI */
+	{0, 0, 0, 0, 47, 0,  91, 133, 171, 242, 305, 334, 362}, /* AGG */
+	{0, 0, 0, 0, 52, 0, 101, 145, 187, 264, 330, 361, 390}, /* AGG+SGI */
 };
 
 static s32 expected_tpt_siso40MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0,  77, 0, 127, 160, 184, 220, 242, 250, 257}, /* Norm */
 	{0, 0, 0, 0,  83, 0, 135, 169, 193, 229, 250, 257, 264}, /* SGI */
-	{0, 0, 0, 0,  96, 0, 182, 259, 328, 451, 553, 598, 640}, /* AGG */
-	{0, 0, 0, 0, 106, 0, 199, 282, 357, 487, 593, 640, 683}, /* AGG+SGI */
+	{0, 0, 0, 0,  94, 0, 177, 249, 313, 423, 512, 550, 586}, /* AGG */
+	{0, 0, 0, 0, 104, 0, 193, 270, 338, 454, 545, 584, 620}, /* AGG+SGI */
 };
 
 static s32 expected_tpt_mimo2_20MHz[4][IWL_RATE_COUNT] = {
-	{0, 0, 0, 0,  74, 0, 123, 155, 179, 213, 235, 243, 250}, /* Norm */
-	{0, 0, 0, 0,  81, 0, 131, 164, 187, 221, 242, 250, 256}, /* SGI */
-	{0, 0, 0, 0,  92, 0, 175, 250, 317, 436, 534, 578, 619}, /* AGG */
-	{0, 0, 0, 0, 102, 0, 192, 273, 344, 470, 573, 619, 660}, /* AGG+SGI*/
+	{0, 0, 0, 0,  74, 0, 123, 155, 179, 214, 236, 244, 251}, /* Norm */
+	{0, 0, 0, 0,  81, 0, 131, 164, 188, 223, 243, 251, 257}, /* SGI */
+	{0, 0, 0, 0,  89, 0, 167, 235, 296, 402, 488, 526, 560}, /* AGG */
+	{0, 0, 0, 0,  97, 0, 182, 255, 320, 431, 520, 558, 593}, /* AGG+SGI*/
 };
 
 static s32 expected_tpt_mimo2_40MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0, 123, 0, 182, 214, 235, 264, 279, 285, 289}, /* Norm */
 	{0, 0, 0, 0, 131, 0, 191, 222, 242, 270, 284, 289, 293}, /* SGI */
-	{0, 0, 0, 0, 180, 0, 327, 446, 545, 708, 828, 878, 922}, /* AGG */
-	{0, 0, 0, 0, 197, 0, 355, 481, 584, 752, 872, 922, 966}, /* AGG+SGI */
+	{0, 0, 0, 0, 171, 0, 305, 410, 496, 634, 731, 771, 805}, /* AGG */
+	{0, 0, 0, 0, 186, 0, 329, 439, 527, 667, 764, 803, 838}, /* AGG+SGI */
 };
 
 static s32 expected_tpt_mimo3_20MHz[4][IWL_RATE_COUNT] = {
-- 
1.7.0.4

