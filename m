Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:51774
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZCDW6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 17:58:12 -0500
Message-ID: <49AF077D.2020408@erley.org> (sfid-20090304_235815_519118_FC25E57B)
Date: Wed, 04 Mar 2009 17:58:05 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Alexey Yudichev <ayudichev@yahoo.co.uk>
CC: "Christoph .J Thompson" <cjsthompson@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k master (AP) mode
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>	 <4dd58f490903041333y4e2abe8r72204232ec4a65ac@mail.gmail.com>	 <20090304232625.cc47eb46.cjsthompson@gmail.com> <4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
In-Reply-To: <4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alexey Yudichev wrote:
>> On Wed, 4 Mar 2009 21:33:21 +0000
>> Alexey Yudichev <ayudichev@yahoo.co.uk> wrote:
>>> Hello,
>>>
>>> I've just joined the list so don't know how to join the same thread so
>>> to indicate that it's the same matter I use the same subject. I am
>>> trying to make my "04:01.0 Ethernet controller: Atheros Communications
>>> Inc. Atheros AR5001X+ Wireless Network Adapter (rev 01)" which is
>>> identified by ath5k as
>>> [   10.356742] ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
>>> [   10.356748] ath5k phy0: RF5112B multiband radio found (0x36)
>> I have the exact same card (AR5001X+) working in master mode with hostapd. What kernel version and hostapd version do you use?
> 
> Hi, I use 2.6.27-11-generic (from ubuntu's
> linux-backports-modules-intrepid-generic), hostapd v0.5.10.

I don't know if it's intended, or just not implemented, but iwconfig <iface> mode master
won't work with mac80211 drivers.  Hostapd knows how to set master mode on it's own. 

Pat Erley
