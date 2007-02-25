Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:40303 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311AbXBYEjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Feb 2007 23:39:21 -0500
Message-ID: <45E112F7.9090908@lwfinger.net>
Date: Sat, 24 Feb 2007 22:39:19 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Alex Davis <alex14641@yahoo.com>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: Patch to allow specification of interface name prefix
References: <510326.55988.qm@web50211.mail.yahoo.com> <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net>
In-Reply-To: <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> Quoting Alex Davis <alex14641@yahoo.com>:
> 
>> This patch will allow you to specify the interface name prefix of wireless
>> devices.
>>
>> On my machine, the wireless devices under the bcm43xx driver are named
>> 'ethx'; I
>> would really rather have them called 'wlanx', like bcm43xx-d80211 does.
> 
> You can use ifrename from wireless tools.  Use the option that checks the
> ethtool information.
> 
> Jean has just released Wireless Tools 29-pre12, which can read symlinks in
> sysfs.  That would allow renaming d80211 based network devices by checking the
> "driver" symlinks in sysfs.  I asked Jean to do that with bcm43xx_d80211 in
> mind.
> 
> It's not that I'm against your patch.  I'm rather ambivalent.  But I think using
> ifrename could reduce the need in kernel support for interface renaming.

NACK.

On my system (openSUSE 10.2), one sets the name in /etc/udev/rules.d/30-net_persistent_names.rule. I
feel that interface renaming is handled perfectly well in userland, and kernel support is not needed.

Larry
