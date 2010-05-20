Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24122 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab0ETWC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 18:02:29 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 15:02:29 -0700
From: David Quan <David.Quan@Atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Bruno Randolf <br1@einfach.org>
CC: "ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Thu, 20 May 2010 15:02:27 -0700
Subject: RE: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna
 	configuration
Message-ID: <93781E992CBA7843962D8B0E7D683F3C1116F33120@SC1EXMB-MBCL.global.atheros.com>
References: <20100519012528.22206.77550.stgit@tt-desk>
 <201005201121.49846.br1@einfach.org>
 	<AANLkTilG3c2UDEQa66PMvKysRVTt_dd-ZAS8FiDOe4Ob@mail.gmail.com>
 	<201005201436.11667.br1@einfach.org>
 <AANLkTilk0CIkmmIsBzPwchd6EBIVavw9R1amiSgCZOrx@mail.gmail.com>
In-Reply-To: <AANLkTilk0CIkmmIsBzPwchd6EBIVavw9R1amiSgCZOrx@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rangemax is a proprietary design by netgear and their 3rd party, there is no way for us to control 
their antenna array. yes, this is a legacy non 11n design with more than 2 antenna.
 

-----Original Message-----
From: mcgrof@gmail.com [mailto:mcgrof@gmail.com] On Behalf Of Luis R. Rodriguez
Sent: Wednesday, May 19, 2010 11:44 PM
To: Bruno Randolf; David Quan
Cc: ath5k-devel@lists.ath5k.org; linux-wireless@vger.kernel.org; linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna configuration

On Wed, May 19, 2010 at 10:36 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Thursday 20 May 2010 14:17:19 you wrote:
>> None of the legacy 802.11 drivers we support have more than 2
>> antennas, I am also not aware of any.
>
> i have heard of some solutions based on atheros chipsets with more than 2
> antennas ("pre-11n RangeMax", "large phased array switch"). please check
> internally.

I will. David, are you aware of legacy (non 802.11n) devices with more
than 2 antennas?

>> But -- I can think of using an 802.11n device in legacy
>> mode of operation using specific antennas.... so there's your example
>> of a valid case for this.
>
> thanks! :)
>
>> Legacy devices are dead. I don't know anyone in the industry making
>> them, the 1 stream 802.11n devices are cheaper today, so there is no
>> point in the market for it.
>
> that might be true from a chipset manufacturers marketing perspective - but we
> work on the linux kernel... ;)
>
> as you know there are millions of so called "legacy" chipsets out there and
> people are going to continue to use them wether your marketing declares them
> "dead" or not... i think it's worth to properly support them.
>
> also please don't forget that some people use the linux kernel not just for
> standard use cases, but for research and developing new solutions. we should
> provide the flexibility to support that, if possible.

Heh, yeah but what goes into the Linux kernel are drivers for hardware
silicon companies make. Who is making new legacy chipsets still?

>> > and we are sure we don't want to support more than 2
>> > antennas - well, we could save 6 bits... is it really worth it?
>>
>> You're right, then if you really don't mind lets think 802.11n through
>> well then.
>
> i don't mind to do that, but as i said i dont know much about 802.11n yet.

Thanks, give me some time to think about this then and get back to you.

  Luis
