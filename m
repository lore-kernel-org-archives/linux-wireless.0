Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbYDDAEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 20:04:39 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: mac80211: ieee80211_ops.bss_info_changed question
Date: Thu, 3 Apr 2008 17:02:23 -0700
Message-ID: <D936D925018D154694D8A362EEB08920041CC3C6@orsmsx416.amr.corp.intel.com> (sfid-20080404_010441_051046_36BC4F51)
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

In the comments about bss_info_changed it is said that the callback has
to be atomic. I was looking at it and could only find that it is called
either from the workqueue or an ioctl. It thus seems that we may be able
to sleep in there. I likely missed the spot where it needs to be atomic
... could you please direct me to it?

Thanks

Reinette
