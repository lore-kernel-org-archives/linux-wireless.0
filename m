Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21382 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbZDURto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 13:49:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/2] iwlwifi DMA fixes
Date: Tue, 21 Apr 2009 10:55:46 -0700
Message-Id: <1240336548-20913-1-git-send-email-reinette.chatre@intel.com> (sfid-20090421_194955_667845_E67A82F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

The first patch is a small but very useful debugging patch. The
second patch contains a few fixes to iwlwifi's DMA handling.
The second patch depends on the first.

Could you please apply these two patches to 2.6.30 as well as
wireless-testing?

[PATCH v2.6.30 and w-t 1/2] iwlwifi: add debugging for TX path
[PATCH v2.6.30 and w-t 2/2] iwlwifi: DMA fixes

Thank you

Reinette
