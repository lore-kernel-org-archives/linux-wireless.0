Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mr1.bfh.ch ([147.87.250.50]:36458 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695AbYEPNsf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 09:48:35 -0400
From: Michael Bernhard <michael.bernhard@bfh.ch>
To: mcgrof@winlab.rutgers.edu
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] compat-2.6: Enable iwlwifi build
Date: Fri, 16 May 2008 15:48:45 +0200
Message-Id: <12109457273057-git-send-email-michael.bernhard@bfh.ch> (sfid-20080516_154840_990286_E6D8633D)
In-Reply-To: <1210945725582-git-send-email-michael.bernhard@bfh.ch>
References: <1210945725582-git-send-email-michael.bernhard@bfh.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Bernhard <michael.bernhard@bfh.ch>
---
 config.mk |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index eef472b..4256a1a 100644
--- a/config.mk
+++ b/config.mk
@@ -30,6 +30,7 @@ ifneq ($(CONFIG_PCI),)
 
 CONFIG_ATH5K=m
 CONFIG_ATH5K_DEBUG=n
+CONFIG_IWLWIFI=m
 CONFIG_IWLCORE=m
 CONFIG_IWL3945=m
 CONFIG_IWL4965=m
-- 
1.5.2.5

