Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56466 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200AbZATUIg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 15:08:36 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 12:08:36 -0800
Date: Tue, 20 Jan 2009 12:08:02 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Catalin Patulea <cat@vv.carleton.ca>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Atheros (madwifi/ath5k) virtual STA support
Message-ID: <20090120200802.GF19581@tesla> (sfid-20090120_210841_348820_F3D5AA99)
References: <9664a4720901201133g5671c7f0x718c4bd187b1d901@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <9664a4720901201133g5671c7f0x718c4bd187b1d901@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 11:33:13AM -0800, Catalin Patulea wrote:
> Hi linux-wireless,
> 
> I'm interested in virtual STA support in madwifi and/or ath5k on an
> AR5414 (AR5006XS). Specifically, I want one physical wireless adapter
> to act as an infrastructure client on multiple networks. I understand
> the network will most likely need to be on the same channel.
> 
> This is currently prohibited by the madwifi driver (haven't looked at
> ath5k thoroughly). What's the underlying reason for this? Someone on
> IRC mentioned powersaving, beacon handling and "other reasons". Can
> anyone elaborate?

Please use linux-wireless only for upstream drivers like ath5k or ath9k.

You will most likely see this first implemented in ath9k. Work is underway
for just that.

> Secondly, what is the procedure to get hardware documentation from
> Atheros? I'm specifically interested in the AR5414 datasheet.

Please see:

http://wireless.kernel.org/en/developers/Documentation/specs#Atherosspecifications

  Luis
