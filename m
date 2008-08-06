Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:48833 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbYHFQWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 12:22:49 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1169594nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 09:22:47 -0700 (PDT)
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: Are these Ralink chips supported?
Date: Wed, 6 Aug 2008 18:47:55 +0200
Cc: linux-wireless@vger.kernel.org
References: <20080805163234.GA22429@storm.local.network> <200808061014.10483.IvDoorn@gmail.com> <g7cinp$g4u$1@ger.gmane.org>
In-Reply-To: <g7cinp$g4u$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808061847.55912.IvDoorn@gmail.com> (sfid-20080806_182256_526833_35A871BB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 August 2008, Daniel Gimpelevich wrote:
> On Wed, 06 Aug 2008 10:14:10 +0200, Ivo van Doorn wrote:
> 
> > On Tuesday 05 August 2008, Forest Bond wrote:
> >> Hi,
> >> 
> >> I'm having a hard time figuring out if the following wireless chips are
> >> supported:
> >> 
> >>  * RT2770 + RT2720
> > 
> > I *think* this is the rt2870 driver. The in-kernel driver is under
> > development
> 
> That is indeed rt2800usb. I don't have any rt2800usb hardware myself yet, 
> but I would like to test rt2800pci when testable code is available. Any 
> ETA?

First testable code should be done within a week, but that one is unlikely
to work. I hope to have something "able to send and receive" ready in 2 or
3 weeks.

When the test version is ready I'll send out a notice to linux-wireless with
a link to the patches.

Ivo
