Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([5.9.2.179]:42458 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbcAGQ7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 11:59:44 -0500
Subject: Re: lost connectivity until "wpa_cli reassociate" is issued
To: David Mosberger <davidm@egauge.net>,
	Ben Greear <greearb@candelatech.com>
References: <CALnQHM3C=DVaTf58XDyh+rttVs-FSpc4ghozg9HJktEonq7w-g@mail.gmail.com>
 <568E913D.7050301@candelatech.com>
 <CALnQHM1mzqFbprQqujB7BWncOa=D9uAxLQ0paiv-21vrx+hFvw@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Bruno Randolf <br1@einfach.org>
Message-ID: <568E997C.1030003@einfach.org> (sfid-20160107_175946_977332_D5778527)
Date: Thu, 7 Jan 2016 16:59:40 +0000
MIME-Version: 1.0
In-Reply-To: <CALnQHM1mzqFbprQqujB7BWncOa=D9uAxLQ0paiv-21vrx+hFvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2016 04:29 PM, David Mosberger wrote:
> On Thu, Jan 7, 2016 at 9:24 AM, Ben Greear <greearb@candelatech.com> wrote:
>> On 01/07/2016 08:19 AM, David Mosberger wrote:
>>>
>>> We are seeing a curious issue where WLAN connectivity sometimes
>>> gets stuck until a "wpa_cli reassociate" command is issued.
>>>
>>> At the WPA level, everything appears to be working fine)
>>> (see thread starting at
>>> http://lists.infradead.org/pipermail/hostap/2016-January/034454.html).
>>
>> I don't remember seeing you mention the driver and NIC you are using.
>>
>> I think this is likely a driver bug, so please provide that info.
> 
> Sure, we're using rtl8192cu.  I started out suspecting a driver bug as
> well, but since we're processing management frames during those
> "stuck" periods just fine (see

Although I have not checked if the "wpa_cli reassociate" command helps,
I have seen rtl8192cu get "stuck" in similar ways. Maybe you can give
the new rtl8xxxu driver from Jes Sorensen try? It has less features, but
works more reliable, IMHO...

bruno
