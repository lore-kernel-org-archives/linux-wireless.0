Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([204.127.217.105]:61064 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZCZT7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 15:59:21 -0400
Message-ID: <49CBDE6A.6040702@lwfinger.net> (sfid-20090326_205924_604709_EE446F77)
Date: Thu, 26 Mar 2009 14:58:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: david@identd.dyndns.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT/RFC 1/2] b43legacy: Fixes for beacons
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch ports the beaconing fixes from commit a82d992261f "b43: Beaconing
fixes" to b43legacy. Basically it prevents the card from triggering the beacon
IRQ over and over again.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Did these 2 patches work for you?

Larry



