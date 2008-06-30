Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:8673 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbYF3Qk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 12:40:28 -0400
Received: by py-out-1112.google.com with SMTP id p76so335917pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 09:40:27 -0700 (PDT)
Message-ID: <1ba2fa240806300940v35c5f2efq6a7036de096006bc@mail.gmail.com> (sfid-20080630_184032_207387_64E46164)
Date: Mon, 30 Jun 2008 19:40:26 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: IBSS lockdep failure
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <1214842913.5507.58.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240806300848v4fd92b72n565fc113e1c122b8@mail.gmail.com>
	 <1214841181.5507.54.camel@johannes.berg>
	 <1ba2fa240806300914n7d28f874i4ee43cb999903135@mail.gmail.com>
	 <1214842913.5507.58.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 7:21 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-06-30 at 19:14 +0300, Tomas Winkler wrote:
>> On Mon, Jun 30, 2008 at 6:53 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> >
>> >> phy0: Adding new IBSS station XX:XX:XX:XX:XX:XX (dev=wlan0)
>> >
>> > are all of those XX entries the same?
>>
>> Not they are not. Sorry for the paranoia :)
>
> Being able to distinguish them at least would help.

Here you go.

wlan0: beacon TSF higher than local TSF - IBSS merge with BSSID
XX:XX:XX:XX:XX:XD
phy0: Adding new IBSS station XX:XX:XX:XX:XX:X1 (dev=wlan0)
phy0: Allocated STA XX:XX:XX:XX:XX:X1
phy0: Inserted STA XX:XX:XX:XX:XX:X1
wlan0: RX ProbeReq SA=XX:XX:XX:XX:XX:X1 DA=ff:ff:ff:ff:ff:ff
BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
wlan0: Sending ProbeResp to XX:XX:XX:XX:XX:X1
RX beacon SA=XX:XX:XX:XX:XX:XC BSSID=XX:XX:XX:XX:XX:XD TSF=0x14dc0bd5c
BCN=0x14dc0be19 diff=-189 @1071562
wlan0: beacon TSF higher than local TSF - IBSS merge with BSSID
XX:XX:XX:XX:XX:XD
phy0: Removed STA XX:XX:XX:XX:XX:X1
phy0: Removed STA XX:XX:XX:XX:XX:X2
phy0: Removed STA XX:XX:XX:XX:XX:X3
phy0: Removed STA XX:XX:XX:XX:XX:X4
phy0: Removed STA XX:XX:XX:XX:XX:X5
phy0: Removed STA XX:XX:XX:XX:XX:X6
phy0: Removed STA XX:XX:XX:XX:XX:X7
phy0: Removed STA XX:XX:XX:XX:XX:X8
phy0: Removed STA XX:XX:XX:XX:XX:X9
phy0: Removed STA XX:XX:XX:XX:XX:XA
phy0: Removed STA XX:XX:XX:XX:XX:XB
phy0: Removed STA XX:XX:XX:XX:XX:XC
phy0: Destroyed STA XX:XX:XX:XX:XX:X1
phy0: Destroyed STA XX:XX:XX:XX:XX:X2
phy0: Destroyed STA XX:XX:XX:XX:XX:X3
phy0: Destroyed STA XX:XX:XX:XX:XX:X4
phy0: Destroyed STA XX:XX:XX:XX:XX:X5
phy0: Destroyed STA XX:XX:XX:XX:XX:X6
phy0: Destroyed STA XX:XX:XX:XX:XX:X7
phy0: Destroyed STA XX:XX:XX:XX:XX:X8
phy0: Destroyed STA XX:XX:XX:XX:XX:X9
phy0: Destroyed STA XX:XX:XX:XX:XX:XA
phy0: Destroyed STA XX:XX:XX:XX:XX:XB
phy0: Destroyed STA XX:XX:XX:XX:XX:XC
BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<c043d4eb>] zap_class+0x22/0x64
*pde = 00000000
Oops: 0002 [#1] SMP
Modules linked in: mac80211 cfg80211 netconsole i915 drm autofs4 hidp
rfcomm l2cap sunrpc cpufreq_ondemand acpi_cpufreq dm_multipath sbs
