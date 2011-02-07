Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:51042 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524Ab1BGVBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 16:01:22 -0500
Date: Mon, 7 Feb 2011 23:01:08 +0200
From: Jouni Malinen <j@w1.fi>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: Ben Greear <greearb@candelatech.com>,
	Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Scanning and channel types.
Message-ID: <20110207210108.GA13358@jm.kir.nu>
References: <4D4EFD87.4010005@openwrt.org>
 <4D4EFF68.9060101@candelatech.com>
 <AANLkTin6ia8mYsS4LOFTyZoD-dKUgUBGo6uMFt=FjTcY@mail.gmail.com>
 <4D4F0D83.4040401@candelatech.com>
 <4D4F0DFF.9010703@openwrt.org>
 <AANLkTin=zENpxMQYe65Vxs7oSVqe37Lt3mgiPp=L-jzA@mail.gmail.com>
 <4D5033DE.4070701@candelatech.com>
 <AANLkTimzp3nL=vbxnhH2ZYZtGNFqMsKKqTw1+pfjkUMu@mail.gmail.com>
 <4D50503E.4090007@candelatech.com>
 <AANLkTim_rcWdzPhraUaTvC_C3-Tm5_w5xH6xHOK=mviE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTim_rcWdzPhraUaTvC_C3-Tm5_w5xH6xHOK=mviE@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 07, 2011 at 12:10:57PM -0800, Daniel Halperin wrote:
> No HT20 is not the same as HT-Only.  I'm not sure how to set that. Jouni?

What is a "HT-Only" AP and where is this defined? Are you saying that
there would be an AP that would be unable to receive a frame at 1 Mbps
on 2.4 GHz band or 6 Mbps on 5 GHz band? I would assume that normal way
of enforcing HT only BSS would be to reject non-HT STAs from associating
with it, but I would be a bit surprised if the AP actually disables RX
of non-MCS rates.

-- 
Jouni Malinen                                            PGP id EFC895FA
