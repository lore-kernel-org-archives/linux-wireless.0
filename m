Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60414 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0A0UiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 15:38:00 -0500
Received: by bwz19 with SMTP id 19so5157898bwz.28
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2010 12:37:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <17290.75428.qm@web24706.mail.ird.yahoo.com>
References: <4dd58f491001270218t4eaac711xcb42658f8fbf375c@mail.gmail.com>
	 <17290.75428.qm@web24706.mail.ird.yahoo.com>
Date: Wed, 27 Jan 2010 20:37:58 +0000
Message-ID: <4dd58f491001271237o66bc7cd1p968a8894f324533d@mail.gmail.com>
Subject: Re: wlan/eth bridge stops working after a while: how to diagnose?
From: Alexey Yudichev <ayudichev@gmail.com>
To: John Murdoch <weejoker@yahoo.com>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, I kept my symptoms simpler not to risk confusing more than one
issue but indeed in many cases the client stops seeing the access
point at all. Restarting hostapd fixes the network visibility but most
likely does not fix the actual IP connectivity. Client keeps getting
IP address correctly though so DHCP works.

On Wed, Jan 27, 2010 at 6:39 PM, John Murdoch <weejoker@yahoo.com> wrote:
> --- On Wed, 27/1/10, Alexey Yudichev <ayudichev@gmail.com> wrote:
>
>> I've got ubuntu 9.10 (hostapd 0.6.9)
>> + compat-wireless-2009-12-11 and
>> the box is acting as a basic wireless internet router.
>> Driver is ath9k
>> and server adapter is D-Link DWA-547. All is working fine
>> for 2-3 days
>> until all of a sudden wireless client (MacBook Pro) stops
>> pinging any
>> hosts on a local network. The wireless association remains
>> and hostapd
>> logs are not showing anything unusual. Restarting hostapd
>> or even
>> networking does not help (although I believe restarting
>> networking
>> does not work well on ubuntu anyway). Only rebooting the
>> server helps.
>
> I've been having the same problems for a long time with two different Mini-PCI cards (AR5416 & AR9160) on Debian 5.0 w/ kernel 2.6.32, with various hostapd and compat-wireless releases (latest combination being hostapd 0.7.1 / compat-wireless 2010-01-26).
>
> Both cards have similar issues where hostapd permanently stops transmitting beacons from between 10mins to just over 24hrs. There's absolutely nothing in any logs to suggest issues. I can however restart hostapd and the problem is immediately resolved.
>
>> What would you advise to check/debug or otherwise what
>> would be the
>> best approach to diagnose the problem? I don't see
>> anything
>> interesting in dmesg, messages or daemon.log at this
>> point.
>
> I'm more than willing to collect logs too if pointed in the right direction.
>
> Regards,
>
> John
>
>
>
>
>
>
