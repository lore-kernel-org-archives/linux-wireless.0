Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbaEZQGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 12:06:39 -0400
From: Jes.Sorensen@redhat.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/1] wireless: Add missing WLAN_EID 73
Date: Mon, 26 May 2014 18:06:33 +0200
Message-Id: <1401120394-22503-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20140526_180712_610838_A5353708)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

The rtl8723au driver references EID 73 and carries a local copy of
it. It seems to make more sense to put it in next to all the others.

It would be great if we could get this in soon for 3.16 so I can make
the matching change in the staging tree driver :)

Cheers,
Jes


Jes Sorensen (1):
  include/linux/ieee80211.h: Add missing
    WLAN_EID_BSS_INTOLERANT_CHL_REPORT

 include/linux/ieee80211.h | 1 +
 1 file changed, 1 insertion(+)

-- 
1.9.3

