Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43088 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbZFZRxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2009 13:53:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/3] iwlwifi driver updates 06/26/2009
Date: Fri, 26 Jun 2009 11:00:52 -0700
Message-Id: <1246039255-2195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We re-enable indication that iwlwifi supports PS. The rest is just
debugging help.

[PATCH 1/3] iwlagn: re-enable PS support for iwlagn
[PATCH 2/3] iwlwifi: add utility to print buffer when error occurs
[PATCH 3/3] iwlwifi: always print buffer when error condition occurs

Reinette

