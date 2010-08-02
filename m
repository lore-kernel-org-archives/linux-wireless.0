Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chmmr.gsimmons.org ([65.19.178.248]:53079 "EHLO
	chmmr.gsimmons.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0HBG0S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 02:26:18 -0400
Date: Mon, 2 Aug 2010 16:17:52 +1000
From: Geoff Simmons <gsimmons@gsimmons.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Cozatt <olbrannon@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: SMC 2802W -status unsupported
Message-ID: <20100802061752.GA12126@tammy.lan.gsimmons.org>
References: <AANLkTinU74hoPQ9tfZp12n_rQQX38OYy2qaETON-qGAu@mail.gmail.com> <4C55DA66.3090507@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C55DA66.3090507@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 01, 2010 at 03:34:46PM -0500, Larry Finger wrote:
> Looking at the driver code, we need the patch below to enable the
> device:
[...]
> +       /* Standard Microsystems Corp SMC2802W Wireless PCI */
> +       { PCI_DEVICE(0x10b8, 0x2802) },

No, 10b8:2802 is the subsystem ID of the SMC2802W v1.

Both v1 and v2 use 1260:3890 as their device ID, which is already
defined in p54pci.c.  Your patch is not necessary.

Geoff
