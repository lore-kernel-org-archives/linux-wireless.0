Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60059 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbZGVPsF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 11:48:05 -0400
Subject: Re: any controller working in AP mode ?
From: Pavel Roskin <proski@gnu.org>
To: Ram kumar <ramkumar.research@gmail.com>
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1247843954.25608.62.camel@mj>
References: <6306c640907142221o27c257aaw12f73da8118376f@mail.gmail.com>
	 <445f43ac0907151344q6d80ddeckc0c586b34d8ca7c5@mail.gmail.com>
	 <6306c640907152338k4a5fb474h481d5adba97507b1@mail.gmail.com>
	 <1247843954.25608.62.camel@mj>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 11:48:02 -0400
Message-Id: <1248277682.8929.0.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-17 at 11:19 -0400, Pavel Roskin wrote:

> > It would be very helpful if anyone can guide me,how to get the
> > hardware for MARVELL 8388.
> 
> 5 minute search finds that Zonet ZEW2502 is what you need.  There is
> only one driver for that device on the Zonet site, and it's clearly for
> Marvell.

Just for the record, it turns out the device is not supported, even
though it's Marvell:

Bus 001 Device 005: ID 1286:1fab Marvell Semiconductor, Inc. 

Both libertas drivers support only 1286:2001 and 05a3:8388.

Web search for 1286:1fab doesn't find anything useful other than
recommendations to use ndiswrapper.

I should have checked the ID in the *.inf files against the kernel
sources.

-- 
Regards,
Pavel Roskin
