Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:41879 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965614AbXBTAQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 19:16:55 -0500
Message-ID: <45DA3DEA.2040507@lwfinger.net>
Date: Mon, 19 Feb 2007 18:16:42 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Alex Davis <alex14641@yahoo.com>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Kernel bug in bcm43xx-d80211
References: <508755.46267.qm@web50206.mail.yahoo.com>
In-Reply-To: <508755.46267.qm@web50206.mail.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alex Davis wrote:
> --- Pavel Roskin <proski@gnu.org> wrote:
> 
>> On Mon, 2007-02-19 at 13:48 -0800, Alex Davis wrote:
>>> I go the following Oops with the latest wireless-dev git when starting wpa_supplicant:
>> Wireless topics moved from this list to linux-wireless@vger.kernel.org.
>> Broadcom drivers are discussed in bcm43xx-dev@lists.berlios.de.
>> wireless-dev is horribly broken, and the fixes haven't been merged yet.
>>
>> The current Broadcom driver can be loaded from
>> http://bu3sch.de/git/wireless-dev.git (please load it on top of
>> wireless-dev.git to save bandwidth)
> What command do I use to load Mike's tree on top of wireless-dev?

While in the wireless-dev tree, issue the following:

git branch michael
git checkout michael
git pull http://bu3sch.de/git/wireless-dev.git master

To get back to the original wireless-dev tree, us a 'git checkout master' command.

Larry
