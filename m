Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:37773 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbYKTIuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 03:50:22 -0500
Received: by nf-out-0910.google.com with SMTP id d3so169517nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 00:50:20 -0800 (PST)
Message-ID: <f76a32050811200050u48bc150en34e94c7671672ae6@mail.gmail.com> (sfid-20081120_095026_557603_D2FDAF6C)
Date: Thu, 20 Nov 2008 09:50:20 +0100
From: "Stefan Steuerwald" <salsasepp@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227126204.26243.62.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <f76a32050811190316o28a49cddte30214c217877078@mail.gmail.com>
	 <1227095773.26243.22.camel@johannes.berg>
	 <f76a32050811190737w37937e17ra361364ed345fd33@mail.gmail.com>
	 <1227109286.26243.54.camel@johannes.berg>
	 <f76a32050811190823r51033a4dqa29de6d1e6663388@mail.gmail.com>
	 <1227126204.26243.62.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/19 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2008-11-19 at 17:23 +0100, Stefan Steuerwald wrote:
>
>> At first glance this improves things, but not enough. I have an ajax
>> application that is polling the web server and which runs into its 5
>> sec timeouts fairly regularly. [...deleted...]
>
> What's your client? Is it using powersave? Anyone know whether
> multicast-after-dtim works correctly in p54? Or maybe there's a bug
> hitting with TIM bits? Do you have an extra card that you could use to
> monitor and see what happens when it times out?

I have tested multiple clients at this time with my XG-601/ISL3880 p54 card:
- iPod Touch 2G with firmware 2.1.1
- Sony Vaio with a Marvell 88E8036 (Vista SP1)
- Amilo Notebook with Intel 4965AGN (stock Ubuntu 8.10)
- Amilo Notebook with Netgear USB-WLAN-Stick with RTL8187B (stock Ubuntu 8.10)

Interestingly, only the iPod is unusable, with constant timeouts of my
web-app. The other clients work 99% of the time with an _occasional_
timeout. I have multiple clients connected at the same time, and never
saw a simultaneous timeout with any two clients. I have also a wired
reference connection which never exhibits any timeouts.

I have no clue about iPod powersave. On the 4965 and the RTL8187 it
seems to be off (iwconfig output).

I do have indications of "general" WLAN problems with the iPod
(Apple's support forum is brimming with complaints). There may not be
any AP-related problem at all.

I will learn how to set up a card in monitor mode and post more info
if anything looks suspicious.

Thanks!
  Stefan.
