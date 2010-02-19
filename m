Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43635 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab0BSRGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 12:06:25 -0500
Received: by bwz1 with SMTP id 1so255024bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 09:06:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266598974.3754.0.camel@jlt3.sipsolutions.net>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
	<1266591292.15178.1.camel@jlt3.sipsolutions.net> <4B7EB31D.2000603@lwfinger.net>
	<1266596602.15178.2.camel@jlt3.sipsolutions.net> <4B7EBF0A.1060907@lwfinger.net>
	<1266598974.3754.0.camel@jlt3.sipsolutions.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 19 Feb 2010 18:06:03 +0100
Message-ID: <69e28c911002190906n647d1a25o5f7268c585fa05c8@mail.gmail.com>
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs
	definitions
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2010 at 6:02 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-02-19 at 10:40 -0600, Larry Finger wrote:
>
>> Rafał is taking exams now, but said in one of our last communications
>> that he
>> was finishing up some radio code. After that, he expected some signs
>> of life.
>
> Neat.
>
>> What PHY revision do you have? Between 2 and 3 there were a lot of
>> changes
>> including a new radio version. Rafał has a 2, thus he has been
>> concentrating on
>> that one.
>>
>> Do you have any log messages on the SSB adjustments?
>
> [    5.861375] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x17, vendor 0x4243)
> [    5.861390] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x10, vendor 0x4243)
> [    5.861402] ssb: Core 2 found: PCI-E (cc 0x820, rev 0x0B, vendor 0x4243)
> [    5.861414] ssb: Core 3 found: PCI (cc 0x804, rev 0x0E, vendor 0x4243)
> [    5.861427] ssb: Core 4 found: USB 2.0 Device (cc 0x81A, rev 0x05, vendor 0x4243)
> [    5.861439] ssb: Core 5 found: UNKNOWN (cc 0x8FF, rev 0x00, vendor 0x4243)
> [    5.861452] ssb: Core 6 found: Internal Memory (cc 0x80E, rev 0x03, vendor 0x4243)
> [    5.900494] ssb: Found rev 2 PMU (capabilities 0x04583002)
> [    5.900500] ssb: ERROR: PLL init unknown for device 4322
> [    5.900844] ssb: ERROR: PMU resource config unknown for device 4322
> [    5.909764] ssb: SPROM revision 8 detected.

Hmm... rev8 SPROM in an N-PHY?
Or is this a "low-cost" N-PHY with actual N support disabled (similar
to Ralink RT2070)?

> ...
> [    6.378717] b43-phy0: Broadcom 4322 WLAN found (core revision 16)
> [    6.482611] b43-phy0 debug: Found PHY: Analog 8, Type 4, Revision 4
> [    6.482638] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2056, Revision 3
>
>
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
