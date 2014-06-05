Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaFEMoW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 08:44:22 -0400
From: Jes.Sorensen@redhat.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/1] ieee80211.h: Add definitions for 20/40 BSS Coexist Mgmt action frame
Date: Thu,  5 Jun 2014 14:44:14 +0200
Message-Id: <1401972255-18815-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20140605_144425_879891_75684557)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

The 8723au driver issues BSS Coexistence Mgmt Action Frames, so rather
keeping defines for this in a private driver header, I added it to the
shared ieee80211.h header.

This is from section 8.5.8.2 in the 802.11-2012 spec.

Cheers,
Jes


Jes Sorensen (1):
  ieee80211.h: Add definitions for 20/40 BSS Coexistence Management
    action frame

 include/linux/ieee80211.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

-- 
1.9.3

