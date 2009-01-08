Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:36257 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672AbZAHQdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 11:33:55 -0500
Received: by bwz14 with SMTP id 14so27542449bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 08:33:53 -0800 (PST)
Message-ID: <da94abde0901080833vbd5de49p8dd5ac33c4857c36@mail.gmail.com> (sfid-20090108_173400_068787_014D2D28)
Date: Thu, 8 Jan 2009 18:33:53 +0200
From: "Kalle Valo" <kalle.valo@iki.fi>
To: Claudio <der.claudio@aon.at>
Subject: Re: status of at76-usb driver
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Greg KH" <gregkh@suse.de>
In-Reply-To: <1231426604.4966142c2f17c@webmail.aon.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1230411118.4956956ecb911@webmail.aon.at>
	 <87fxk8o2g0.fsf@litku.valot.fi> <20090106201517.GD3544@tuxdriver.com>
	 <da94abde0901062204r1041cdeawf0a0360cad88741d@mail.gmail.com>
	 <1231426604.4966142c2f17c@webmail.aon.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 8, 2009 at 4:56 PM, Claudio <der.claudio@aon.at> wrote:
> Kalle Valo <kalle.valo@iki.fi> wrote:
>> I have to disagree here. It\'s better not to change at76_usb in staging
>> to avoid any breakage. Like I said, I will submit the mac80211 port
>> with a new name (most probably at76c50x-usb) as soon as I get it
>> stable enough. It\'s good idea to have a working driver in staging tree
>> until the mac80211 has been verified to be working.

s/mac80211/mac80211 port/

Sigh, me and my infamous typos.

> I think so too.
>
>>> Since you mentioned a) that you are working on the port again and b)
>>> you are going to rename the driver for mac80211, should I just drop
>>> my at76 branch of wireless testing for good?
>>
>> Please do, because I will submit at7650x-usb patches from scratch. But
>> don\'t remove at76 branch from the legacy tree, it\'s useful for me:
>
> I am looking forward for testing your new mac80211 version. Please tell
> me where the development happens, so that I can contribute to it.

The development is slow :) I will post any patches to here as I have
them. Currently I'm working on usb protocol decoder so that I can
verify the differences between the original and the mac80211 port.

> Regarding Ubuntu: They are still shipping an ancient version (0.14beta1!).
> Sorry for considering blaming you for the problems.

No problem :)

> The current version of the staging-tree/directory(?) works well.

I didn't find any problems, but I only briefly tested it.

Kalle
