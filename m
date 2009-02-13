Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZBMTrp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 14:47:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/3] iwlwifi driver updates 02/13/2009
Date: Fri, 13 Feb 2009 11:51:16 -0800
Message-Id: <1234554679-30186-1-git-send-email-reinette.chatre@intel.com> (sfid-20090213_204753_943782_C7377BEA)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we fix a txpower warning message. The driver currently
creates a workqueue for every CPU, this is not necessary and now changed.
We also fix and rework the Kconfig file - hopefully this will be the last
change to this file for a while. A compat-wireless patch will be sent
separately.

[PATCH 1/3] iwlwifi: report correct and detailed values about requested txpower
[PATCH 2/3] iwlwifi: use singlethread workqueue
[PATCH 3/3] iwlwifi: Fix and rework Kconfig file


Thank you

Reinette

