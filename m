Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50173 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbZEOXHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 19:07:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/3] iwlwifi driver updates 05/15/2009
Date: Fri, 15 May 2009 16:13:42 -0700
Message-Id: <1242429226-8313-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include two cleanup patches in preparation for more 3945 porting
and a fix to kernel.org bug 13224. For this
bugfix we also include a patch that applies to 2.6.30.

[PATCH 1/3] iwlwifi: drop struct iwl3945_hw_key
[PATCH 2/3] iwlwifi: drop iwl3945_tid_data
[PATCH 3/3] iwlwifi: do not cancel delayed work inside spin_lock_irqsave
[PATCH v2.6.30] iwlwifi: do not cancel delayed work inside spin_lock_irqsave


Thank you

Reinette

