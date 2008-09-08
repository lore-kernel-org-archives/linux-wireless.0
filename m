Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:34168 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081AbYIHTFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 15:05:31 -0400
Message-ID: <48C5777B.9070106@lwfinger.net> (sfid-20080908_210535_126987_CBBD3D7B)
Date: Mon, 08 Sep 2008 14:05:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: feldmaus <feldmann_markus@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: Do not get BCM4303 to work
References: <ga2fra$9q$1@ger.gmane.org>
In-Reply-To: <ga2fra$9q$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

feldmaus wrote:
> Hi All,
> 
> i do not get my Wlan Card with BCM4303 Chip to work.
> 
> I am not sure whether this Card is active, because <dmesg> show me,
> [  409.752921] b43legacy-phy0: Radio hardware status changed to DISABLED

Your card can receive, but not transmit due to a problem with the 
rfkill switch handling in b43legacy. I'm working on this problem with 
a Ubuntu user, and will post patches as soon as the problem is fixed.

Larry
