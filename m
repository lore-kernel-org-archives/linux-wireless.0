Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZFCShQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 14:37:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/6] iwlwifi driver updates 06/3/2009
Date: Wed,  3 Jun 2009 11:44:06 -0700
Message-Id: <1244054652-19451-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains two submissions for the 3945 porting effort. We
also include a fix for some unnecessary error messages in the log as well
as a fix for firmware upload on certain platforms. We clean up some
code in preparation for future work and fix a comment.

[PATCH 1/6] iwlwifi: unify station management
[PATCH 2/6] iwl3945: port allow skb allocation in tasklet patch
[PATCH 3/6] iwl3945/iwlwifi: fix led bug when SW rfkill
[PATCH 4/6] iwlagn: delay ict interrupt.
[PATCH 5/6] iwlwifi: add value and range define for link quality command
[PATCH 6/6] iwlwifi: fix comment describing disable_11n

Thank you

Reinette

