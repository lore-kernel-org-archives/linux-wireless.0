Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5460C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 15:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DAC920878
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 15:21:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DAC920878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=deepplum.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbeKVB4i convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 20:56:38 -0500
Received: from smtp126.iad3a.emailsrvr.com ([173.203.187.126]:57652 "EHLO
        smtp126.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729656AbeKVB4h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 20:56:37 -0500
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2018 20:56:36 EST
Received: from smtp8.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp8.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 469D03942;
        Wed, 21 Nov 2018 10:14:31 -0500 (EST)
X-SMTPDoctor-Processed: csmtpprox beta
Received: from smtp8.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp8.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 3833A537C;
        Wed, 21 Nov 2018 10:14:31 -0500 (EST)
Received: from app14.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
        by smtp8.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 125CB3942;
        Wed, 21 Nov 2018 10:14:31 -0500 (EST)
X-Sender-Id: MAILER-DAEMON
Received: from app14.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
        by 0.0.0.0:25 (trex/5.7.12);
        Wed, 21 Nov 2018 10:14:31 -0500
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
        by app14.wa-webapps.iad3a (Postfix) with ESMTP id F28A7605E6;
        Wed, 21 Nov 2018 10:14:30 -0500 (EST)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Wed, 21 Nov 2018 10:14:30 -0500 (EST)
Date:   Wed, 21 Nov 2018 10:14:30 -0500 (EST)
Subject: RE: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtimeaccounting and scheduling to TXQs
From:   "David P. Reed" <dpreed@deepplum.com>
To:     "Dave Taht" <dave.taht@gmail.com>
Cc:     "Simon Barber" <simon@superduper.net>,
        "Rajkumar Manoharan" <rmanohar@codeaurora.org>,
        "Make-Wifi-fast" <make-wifi-fast@lists.bufferbloat.net>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "ath10k" <ath10k@lists.infradead.org>,
        "Ben Greear" <greearb@candelatech.com>,
        "Felix Fietkau" <nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain;charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <1542813270.991216057@apps.rackspace.com>
X-Mailer: mobile/6.0.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This requires a license to operate. The license comes from your Cellular Provider, only.

It is a gap filler for the Small Cell business concept of 5G, a repeater. 

LTE requires repeaters, too. The MIT Media Lab put in repeaters for each Cellar provider because the Architect specified a shading system for the windows that acts likea Faraday Cage(!). Not the glass, but a fine lattice of horizontal metal bars a few inches from the windows designed to reflect sunlight, but allow view downward - Venetian blinds on the outside.

Not discovered as a problem until occupied! 

But here's the business issue. The Cellcos have to grant spectrum licenses to the Media Lab, it's their "property" even inside buildings! Okay, but what you don't know is that each provider charges a significant fee per month to use "its spectrum" via a repeater. As well as its authorization of the equipment used.

This extends to Small Cells! Just like you can buy a phone, but don't own the right to transmit with it, these repeaters can be bought, but will get their license from a provider (via an eSIMcard, like the new Google Pixel 3 does). Same for these repeaters. 

This is the opposite of what I fought for, along with others, in the Open Spectrum movement I helped start 18 years ago. And what Apple fought for, starting in 1990 in the Part 15 license-by-rule and equipment certification regime.

But I am now retired, from public pro Bono service. We lost. Totally. Both Democrats and Republicans joined to strengthen the Monopoly property rights regime. So did the major parties in the UK and Europe. 

So this equipment will be out of your reach. It's patents extend the Monopoly - they will sue you if you violate the patents, and their cellco customers will demand that these devices be sold only to them, not you, or at least not in a form you can legally operate.

You won't be able to sell any software modifiable repeater in any band. Govt certification of software radios is limited to licensed exclusive bands.

For example, the FCC just ordered a whole range of handheld terminals (walkie talkies) that were intended for Amateur Radio use be pulled from the market because one could transmit outside the Amateur bands. Not that hams would choose to, but because they might! Hams are licensed to design and build any kind of transmitter, self-certifying their own designs, and operating them any way they want, inside the Ham bands. By law they are seriously liable, with fines of 10,000+ dollars for any operation outside those bands. 
But the FCC prevents *sales* of devices to Hams that can transmit outside those bands.

So software radios are illegal, the



-----Original Message-----
From: "Dave Taht" <dave.taht@gmail.com>
Sent: Mon, Nov 19, 2018 at 8:04 pm
To: "Simon Barber" <simon@superduper.net>
Cc: "Simon Barber" <simon@superduper.net>, "Rajkumar Manoharan" <rmanohar@codeaurora.org>, "Make-Wifi-fast" <make-wifi-fast@lists.bufferbloat.net>, "linux-wireless" <linux-wireless@vger.kernel.org>, "ath10k" <ath10k@lists.infradead.org>, "Ben Greear" <greearb@candelatech.com>, "Felix Fietkau" <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtimeaccounting and scheduling to TXQs

On Mon, Nov 19, 2018 at 4:52 PM Simon Barber  wrote:
>
> Low-e glass, it’s a thin metallic film used to reflect infra-red to keep heat in or out. Totally blocks/reflects RF.

Very cool. I imagine it's hell on cell too?

I can see this stuff becoming very popular in places where keeping the
good wifi in is important. Could cover floors and ceilings with it to.
Cars could be tempest rated...

/me goes looking for stock to buy

> Simon
>
> On Nov 19, 2018, at 4:20 PM, Ben Greear  wrote:
>
> On 11/19/2018 04:13 PM, Dave Taht wrote:
>
> On Mon, Nov 19, 2018 at 3:56 PM Ben Greear  wrote:
>
>
> On 11/19/2018 03:47 PM, Dave Taht wrote:
>
> On Mon, Nov 19, 2018 at 3:30 PM Simon Barber  wrote:
>
>
>
>
> On Nov 19, 2018, at 2:44 PM, Toke Høiland-Jørgensen  wrote:
>
> Dave Taht  writes:
>
> Toke Høiland-Jørgensen  writes:
>
> Felix Fietkau  writes:
>
> On 2018-11-14 18:40, Toke Høiland-Jørgensen wrote:
>
> This part doesn't really make much sense to me, but maybe I'm
> misunderstanding how the code works.
> Let's assume we have a driver like ath9k or mt76, which tries to keep a
>
> ….
>
>
> Well, there's going to be a BQL-like queue limit (but for airtime) on
> top, which drivers can opt-in to if the hardware has too much queueing.
>
>
> Very happy to read this - I first talked to Dave Taht about the need for Time Queue Limits more than 5 years ago!
>
>
> Michal faked up a dql estimator 3 (?) years ago. it worked.
>
> http://blog.cerowrt.org/post/dql_on_wifi_2/
>
> As a side note, in *any* real world working mu-mimo situation at any
> scale, on any equipment, does anyone have any stats on how often the
> feature is actually used and useful?
>
> My personal guess, from looking at the standard, was in home
> scenarios, usage would be about... 0, and in a controlled environment
> in a football stadium, quite a lot.
>
> In a office or apartment complex, I figured interference and so forth
> would make it a negative benefit due to retransmits.
>
> I felt when that part of the standard rolled around... that mu-mimo
> was an idea that should never have escaped the lab. I can be convinced
> by data, that we can aim for a higher goal here. But it would be
> comforting to have a measured non-lab, real-world, at real world
> rates, result for it, on some platform, of it actually being useful.
>
>
> We're working on building a lab with 20 or 30 mixed 'real' devices
> using various different /AC NICs (QCA wave2 on OpenWRT, Fedora, realtek USB 8812au on OpenWRT, Fedora,
> and some Intel NICs in NUCs on Windows, and maybe more).  I'm not actually sure if that realtek
>  or the NUCs can do MU-MIMO or not, but the QCA NICs will be able to.  It should be at least somewhat similar
> to a classroom environment or coffee shop.
>
>
> In the last 3 coffee shops I went to, I could hear over 30 APs on
> competing SSIDs, running G, N, and AC,
> occupying every available channel.
>
>
> I especially like when someone uses channel 3 because, I guess, they
> think it is un-used :)
>
> I'm not sure if this was a fluke or not, but at Starbucks recently I sat outside,
> right next to their window, and could not scan their AP at all.  Previously, I sat
> inside, 3 feet away through the glass, and got great signal.  I wonder what that was
> all about!  Maybe special tinting that blocks RF?  Or just dumb luck of some sort.
>
> Thanks,
> Ben
>
>
> --
> Ben Greear 
> Candela Technologies Inc  http://www.candelatech.com
>
>


-- 

Dave Täht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
_______________________________________________
Make-wifi-fast mailing list
Make-wifi-fast@lists.bufferbloat.net
https://lists.bufferbloat.net/listinfo/make-wifi-fast

