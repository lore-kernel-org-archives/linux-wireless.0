Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:34333 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbcDMUIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 16:08:18 -0400
Received: by mail-yw0-f172.google.com with SMTP id d68so82458383ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2016 13:08:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA93jw5d9Er+ZcSszg-gd0X7ZWeQJtqmPFXkf1mwXnTDKxg0xA@mail.gmail.com>
References: <570D8956.8090806@candelatech.com> <1460534484.3057.2.camel@sipsolutions.net>
 <570E472A.2040901@candelatech.com> <CAA93jw5d9Er+ZcSszg-gd0X7ZWeQJtqmPFXkf1mwXnTDKxg0xA@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 14 Apr 2016 01:37:57 +0530
Message-ID: <CABPxzYJFjvMAn8fCcsuqbyq-6Yrim+eXFM2=6pVu=ppmP35x9Q@mail.gmail.com> (sfid-20160413_220822_200411_BAA273AE)
Subject: Re: General VHT rate-ctrl question
To: Dave Taht <dave.taht@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 13, 2016 at 10:31 PM, Dave Taht <dave.taht@gmail.com> wrote:
>
> On Wed, Apr 13, 2016 at 6:18 AM, Ben Greear <greearb@candelatech.com> wrote:
> >
> >
> > On 04/13/2016 01:01 AM, Johannes Berg wrote:
> >>
> >> On Tue, 2016-04-12 at 16:48 -0700, Ben Greear wrote:
> >>>
> >>> If a station and it's peer can both do VHT, is there ever a good
> >>> reason to even try HT rates?
> >>>
> >>
> >> Not really; perhaps if you could do HT greenfield preamble (which VHT
> >> doesn't have) you could get something out of it, beyond that I don't
> >> see a reason to try.
> >>
> >> Unless, for some strange reason, it supports only single stream VHT and
> >> dual-stream HT or something really weird?
> >
> >
> > I was wondering if there was ever a reason that, say 450Mbps HT
> > would work better than MCS-1 for VHT.  Or, maybe a mid-rate HT MCS would
> > have more range than VHT, or something like that.
I dont think so. basically if you remove 256 QAM out of picture,
it just boils down to choosing a modulation scheme which would
be same for VHT and HT. (assuming same BW)

Only advantage is as Johannes pointed, VHT doesn't have greenfield,
so using HT greenfield preamble might be marginally good. Similarly we can
use RIFS for HT(not recommended), But again who uses RIFS/greenfield?
