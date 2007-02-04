Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:45893 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbXBDSn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 13:43:26 -0500
Date: Sun, 4 Feb 2007 10:43:22 -0800
From: Jouni Malinen <jkmaline@cc.hut.fi>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: SoftMAC vs FullMAC
Message-ID: <20070204184322.GC6632@jm.kir.nu>
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com> <20070204123048.4bhesocg4kosgscg@webmail.spamcop.net> <9e4733910702041031i5edd6dfeq7f8c5179fee5e00e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9e4733910702041031i5edd6dfeq7f8c5179fee5e00e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 04, 2007 at 01:31:27PM -0500, Jon Smirl wrote:

> It's not even clear to me that doing encryption is a wireless
> co-processor is a win. It is almost certain that the host can perform
> the same algorithms many times faster that an embedded wireless
> processor.  Moving encryption onto the host reduces the latency of the
> connection.

Well, maybe in some use cases like a modern desktop/laptop CPU with
plenty of CPU power, but hardware acceleration for encryption is a huge
win on most embedded systems (e.g., APs). And like I mentioned, some
FullMAC designs do not even allow the encryption to be moved to the
host..
 
-- 
Jouni Malinen                                            PGP id EFC895FA
