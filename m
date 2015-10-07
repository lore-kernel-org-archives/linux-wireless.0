Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38319 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbbJGHQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 03:16:30 -0400
Received: by wiclk2 with SMTP id lk2so14369587wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2015 00:16:28 -0700 (PDT)
Message-ID: <5614C6CA.7060701@read.org.nz> (sfid-20151007_091633_623588_A6E25609)
Date: Wed, 07 Oct 2015 08:16:26 +0100
From: Morgan Read <mstuff@read.org.nz>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
CC: sgruszka@redhat.com
Subject: Re: iwlegacy and bridging iwl3945...? (sort of)
References: <56118043.3080509@read.org.nz>	 (sfid-20151004_213850_404200_FF308D08) <1444028098.1875.2.camel@sipsolutions.net>
In-Reply-To: <1444028098.1875.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/15 07:54, Johannes Berg wrote:
> On Sun, 2015-10-04 at 20:38 +0100, Morgan Read wrote:
>>
...
>
> (Unless you also control the software on the AP and can run openwrt or
> such and use the Linux-specific 4-addr mode)
>
Thanks for the follow up.

That's certainly a possibilty - I have in the past had Gargoyle on my 
router but, I hadn't installed it on my present router yet because it 
wasn't supported but, I see as of May the tplink c7 archer is 
supported...  Perhaps it's time for an upgrade.

However, before I go down that route are any of the options for bonding, 
which again seem as if they would work, actually a reality?
http://www.codekoala.com/posts/bonding-eth0-and-wlan0-arch-linux/
https://docs.fedoraproject.org/en-US/Fedora/21/html/Networking_Guide/ch-Configure_Network_Bonding.html

Then would the example at the bottom of this page work:
https://docs.fedoraproject.org/en-US/Fedora/18/html/System_Administrators_Guide/s2-networkscripts-interfaces_network-bridge.html
That is, bridging the bonded interfaces?
This is the most appropriate set up for my use.

Many thanks
M

-- 
Morgan Read
UNITED KINGDOM
<mailto:mstuffATreadDOTorgDOTnz>

Confused about DRM?
Get all the info you need at:
http://drm.info/
