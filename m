Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38048 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbaFEMqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 08:46:34 -0400
Message-ID: <1401972383.4168.5.camel@jlt4.sipsolutions.net> (sfid-20140605_144637_187552_B692BF55)
Subject: Re: [PATCH 0/1] ieee80211.h: Add definitions for 20/40 BSS Coexist
 Mgmt action frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Jun 2014 14:46:23 +0200
In-Reply-To: <1401972255-18815-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1401972255-18815-1-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The 8723au driver issues BSS Coexistence Mgmt Action Frames, so rather
> keeping defines for this in a private driver header, I added it to the
> shared ieee80211.h header.

Arguably, it shouldn't, since wpa_supplicant also handles this - or is
it offloaded in some way to the firmware?

johannes

