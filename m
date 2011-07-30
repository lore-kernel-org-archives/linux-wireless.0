Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxout-07.mxes.net ([216.86.168.182]:37552 "EHLO
	mxout-07.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab1G3SOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 14:14:25 -0400
Date: Sat, 30 Jul 2011 19:14:22 +0100
From: Laurence Darby <ldarby@tuffmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: I'm confused and angry
Message-Id: <20110730191422.3b2931ba.ldarby@tuffmail.com> (sfid-20110730_201428_710580_A9C817CF)
In-Reply-To: <4E3442ED.90206@lwfinger.net>
References: <20110730181433.50bd32db.ldarby@tuffmail.com>
	<4E3442ED.90206@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:

> 
> I'm pissed off about the attitude.
> 
> A lot of people spend a lot of time making things work. You
> misconfigure your damned system, and then you go off like this!!!!!
> 
> Read the fucking error message. You have not enabled RFKILL.


I have now enabled rfkill.  The hostapd error message is now:

Hardware does not support configured mode
wlan0: IEEE 802.11 Hardware does not support configured mode (2)
Could not select hw_mode and channel. (-2)
wlan0: Unable to setup interface.
rmdir[ctrl_interface]: No such file or directory

Now what?
