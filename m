Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60456 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0LFULi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 15:11:38 -0500
Received: by iwn9 with SMTP id 9so607938iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 12:11:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CFD3DE3.4000207@candelatech.com>
References: <4CF44543.9070605@candelatech.com>
	<20101130004424.GC1901@tux>
	<4CF6D8C8.2000308@candelatech.com>
	<4CF8A6DE.4020804@candelatech.com>
	<4CFAFBE1.3080505@openwrt.org>
	<4CFB20BA.5090300@candelatech.com>
	<20101206193600.GC21442@tux>
	<4CFD3DE3.4000207@candelatech.com>
Date: Mon, 6 Dec 2010 21:11:37 +0100
Message-ID: <AANLkTingy7fPH14hW_mg8_YcotX29pYCu910Gw48grrD@mail.gmail.com>
Subject: Re: [ath9k-devel] Script to crash ath9k with DMA errors.
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Ben Greear <greearb@candelatech.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 6, 2010 at 8:47 PM, Ben Greear <greearb@candelatech.com> wrote:
> With 16 properly configured non-encrypted stations, running with
> wpa-supplicant
> with netlink driver & sharing scan results,  the interfaces quickly
> associate.
>
> However, I do continue to see DMA warnings such as these (I had picked up my
> portable phone, and it knocked all the interfaces offline ..here
> they are coming back up after I hung up the phone).

Is there some theory as to why using multiple interfaces cause so many
problems with DMA?

/Björn
