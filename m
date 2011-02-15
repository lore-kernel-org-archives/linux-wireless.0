Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:49264 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab1BOAUL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 19:20:11 -0500
Subject: Re: [PATCH] ssb: Make ssb_wait_bit multi-bit safe
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTingds9m3sj5bJoExiuoivbRSAtnF2A-4emjYMdJ@mail.gmail.com> (sfid-20110215_011145_942850_24C2EA9B)
References: <1297725710.5683.17.camel@maggie>
	 <AANLkTingds9m3sj5bJoExiuoivbRSAtnF2A-4emjYMdJ@mail.gmail.com>
	 (sfid-20110215_011145_942850_24C2EA9B)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 01:20:01 +0100
Message-ID: <1297729201.5683.22.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-15 at 01:03 +0100, Gábor Stefanik wrote: 
> > -static int ssb_wait_bit(struct ssb_device *dev, u16 reg, u32 bitmask,
> > -                       int timeout, int set)
> > +static int ssb_wait_bits(struct ssb_device *dev, u16 reg, u32 bitmask,
> > +                        int timeout, int set)
> 
> While you are at it, you may want to change this to "bool set".

Please feel free to submit a separate patch on top of this.

-- 
Greetings Michael.

