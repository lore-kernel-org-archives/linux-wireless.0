Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:35468 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaB0Q3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:29:49 -0500
Received: by mail-ve0-f172.google.com with SMTP id jx11so4063265veb.31
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 08:29:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOAOC6ZhnB=LrJWvG07tOK=b_wWAFO74YdhXWZPxrVCk8=425A@mail.gmail.com>
References: <CAOAOC6a96e5MrEOVY=KXirhUU-rJRv2hgz5B0so9SkWYMpoDfw@mail.gmail.com>
	<1393517094.4648.3.camel@jlt4.sipsolutions.net>
	<CAOAOC6agHr6mVB2jcUx1qHWnBJZyOw0=KP0Wp5BVhrvJgRhmQg@mail.gmail.com>
	<1393517627.4648.4.camel@jlt4.sipsolutions.net>
	<CAOAOC6ZhnB=LrJWvG07tOK=b_wWAFO74YdhXWZPxrVCk8=425A@mail.gmail.com>
Date: Thu, 27 Feb 2014 11:29:48 -0500
Message-ID: <CAOAOC6aoz43LdXBTcRHWqPMvQAVKsH6z4yNqe_hEpT7zouo+Ew@mail.gmail.com> (sfid-20140227_172952_536266_36A3667C)
Subject: Re: pci-half-mini 7260 Wireless AC support 3.13
From: Tim Nelson <tim.l.nelson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As an example, I have screenshot what you see from the controller:

http://i.imgur.com/tEd701u.jpg

These are clients actually associating with the AC radio inside the AP.

On Thu, Feb 27, 2014 at 11:27 AM, Tim Nelson <tim.l.nelson@gmail.com> wrote:
> On a Cisco 5508 controller with a lightweight AP, you can see the
> protocol the radio the client connects to.  If they are in fact AC
> capable, you will see them connect to the AC radio inside the AP
> through the controller.  While I see this with many devices, it never
> happens under linux.  The AP has multiple radios in it.
>
> On Thu, Feb 27, 2014 at 11:13 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Thu, 2014-02-27 at 11:10 -0500, Tim Nelson wrote:
>>> Although it is a similar setup, no.  I am able to connect on ALL
>>> radios but the AC radio's on the 3702's.  I encounter no bugs, no loss
>>> of connection.  However, I NEVER connect to the AC radio on the AP.  I
>>> know it works due to my Nexus 5 connecting to the AC radio
>>> immediately.  If the 3702 saw that my adapter was AC capable, it would
>>> use the AC radio and not the A/N.  Also, every other device with
>>> wireless AC connects fine without issue, even the same laptop on it's
>>> Windows 8 partition.
>>
>> All of this doesn't make a lot of sense to me. What do you even mean by
>> "AC radio" in this context? Is there a separate SSID? BSSID? something
>> else?
>>
>>> If it is AC capable, how do I get it to connect to the AC radio's on
>>> the AP?  It is entirely possible it is something Cisco/Linux related
>>> with how they communicate as well.
>>
>> I don't see how the AP would be able to choose where the client
>> connects, without maybe some CCX stuff that Linux doesn't have.
>>
>> johannes
>>
