Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42054 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1BGULR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 15:11:17 -0500
Received: by iyj8 with SMTP id 8so2514652iyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Feb 2011 12:11:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D50503E.4090007@candelatech.com>
References: <4D4EF004.3040109@candelatech.com> <4D4EF99D.5020601@openwrt.org>
 <4D4EFC76.6090000@candelatech.com> <4D4EFD87.4010005@openwrt.org>
 <4D4EFF68.9060101@candelatech.com> <AANLkTin6ia8mYsS4LOFTyZoD-dKUgUBGo6uMFt=FjTcY@mail.gmail.com>
 <4D4F0D83.4040401@candelatech.com> <4D4F0DFF.9010703@openwrt.org>
 <AANLkTin=zENpxMQYe65Vxs7oSVqe37Lt3mgiPp=L-jzA@mail.gmail.com>
 <4D5033DE.4070701@candelatech.com> <AANLkTimzp3nL=vbxnhH2ZYZtGNFqMsKKqTw1+pfjkUMu@mail.gmail.com>
 <4D50503E.4090007@candelatech.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 7 Feb 2011 12:10:57 -0800
Message-ID: <AANLkTim_rcWdzPhraUaTvC_C3-Tm5_w5xH6xHOK=mviE@mail.gmail.com>
Subject: Re: Scanning and channel types.
To: Ben Greear <greearb@candelatech.com>, j@w1.fi
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 7, 2011 at 12:04 PM, Ben Greear <greearb@candelatech.com> wrote:
>> Start on 5 GHZ AP with HT Only set.  Scan.  What rate are probes sent
>> at for 2.4 GHz?

No HT20 is not the same as HT-Only.  I'm not sure how to set that. Jouni?

> On 5Ghz channels, they are sent at 6Mbps
> On channel 3 (2.4Ghz), they are sent at 1Mbps
>
>
> That seem right?

Yes, for a HT20 but not HT Only AP.

Dan
