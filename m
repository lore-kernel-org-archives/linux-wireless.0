Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab0FBHzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 03:55:07 -0400
Subject: Re: [PATCH] p54spi: replace internal "cx3110x" name with "p54spi"
From: Johannes Berg <johannes@sipsolutions.net>
To: Luke-Jr <luke@dashjr.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org
In-Reply-To: <201006012117.00432.luke@dashjr.org>
References: <201006012117.00432.luke@dashjr.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 09:54:59 +0200
Message-ID: <1275465299.3915.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-01 at 21:16 -0500, Luke-Jr wrote:

>  static struct spi_driver p54spi_driver = {
>  	.driver = {
> -		/* use cx3110x name because board-n800.c uses that for the
> -		 * SPI port */
> -		.name		= "cx3110x",
> +		.name		= "p54spi",
>  		.bus		= &spi_bus_type,

maybe that comment wasn't clear enough ... it needs to be that way to be
properly linked up against SPI.

johannes

