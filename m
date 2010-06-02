Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zinan.dashjr.org ([173.242.112.54]:39637 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081Ab0FBTIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 15:08:44 -0400
From: "Luke-Jr" <luke@dashjr.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54spi: replace internal "cx3110x" name with "p54spi"
Date: Wed, 2 Jun 2010 14:06:05 -0500
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org
References: <201006012117.00432.luke@dashjr.org> <1275465299.3915.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1275465299.3915.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201006021406.15393.luke@dashjr.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 June 2010 02:54:59 am Johannes Berg wrote:
> On Tue, 2010-06-01 at 21:16 -0500, Luke-Jr wrote:
> >  static struct spi_driver p54spi_driver = {
> >  	.driver = {
> > -		/* use cx3110x name because board-n800.c uses that for the
> > -		 * SPI port */
> > -		.name		= "cx3110x",
> > +		.name		= "p54spi",
> >  		.bus		= &spi_bus_type,
> 
> maybe that comment wasn't clear enough ... it needs to be that way to be
> properly linked up against SPI.

I don't understand what you mean here. Does the hardware-side of SPI use 
string identifiers? These are the only two instances of "cx3110x" in the 
kernel source; N8x0 board files expect "p54spi"
