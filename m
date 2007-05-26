Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rwcrmhc14.comcast.net ([204.127.192.84]:33680 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759983AbXEZVlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 17:41:13 -0400
Message-ID: <4658A9A1.9080800@gentoo.org>
Date: Sat, 26 May 2007 17:41:53 -0400
From: Joseph Jezak <josejx@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx-mac80211: Fix for tx_bias equal to 0xFF
References: <465869ce.8wcEX9q9ZmHxX2m3%Larry.Finger@lwfinger.net>	<200705262206.53388.mb@bu3sch.de> <4658A286.1050204@lwfinger.net> <200705262313.35300.mb@bu3sch.de>
In-Reply-To: <200705262313.35300.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 >> Are the txpower adjustment bugs a problem with the specs? Is
there anything I can do?
> 
> I'm not sure what causes this, yet. It's either a bug in estimating
> the current power or in calculating the new attenuation values.
> 

I'm working on updating the v4 specs for estimating the current
power, hopefully I'll finish for tomorrow.  I think the calculation
fo the new attenuation values is okay, but looking over it again
can't hurt.

-Joe
