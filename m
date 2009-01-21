Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37367 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbZAUSze (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 13:55:34 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/2 v2.6.29] iwlwifi driver fixes for 2.6.29
Date: Wed, 21 Jan 2009 10:58:01 -0800
Message-Id: <1232564283-18008-1-git-send-email-reinette.chatre@intel.com> (sfid-20090121_195540_037424_B367D182)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


We would like to include the following two patches as fixes for 2.6.29.
The first patch is of particular interest as it fixes the "rs_get_rate"
issue that is receiving a lot of attention from kerneloops.org. We will
post a patch to stable@kernel.org when this one has been accepted into
Linus's tree.

[PATCH 1/2] iwlwifi: fix rs_get_rate WARN_ON()
[PATCH 2/2] iwlagn: fix agn rate scaling

Thank you

Reinette
