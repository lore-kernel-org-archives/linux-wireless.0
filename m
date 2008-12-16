Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51090 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYLPBaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 20:30:13 -0500
Date: Mon, 15 Dec 2008 20:26:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Jason Self <jason.self@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Realtek wireless 8187se
Message-ID: <20081216012603.GA27773@tuxdriver.com> (sfid-20081216_023019_009935_728A1362)
References: <b76df900812151329x4309b264u7a017e4b4c2d8451@mail.gmail.com> <69e28c910812151355l6549e8c2mea381a12663c7cb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910812151355l6549e8c2mea381a12663c7cb5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 10:55:29PM +0100, Stefanik G=E1bor wrote:

> Looks like this is a MiniPCIE card, so the chip is essentially an
> RTL8187 or RTL8187B with the USB communication part replaced with a
> PCI Express one. Given the existence of this open-source driver,
> adding support for it into rtl818x should not really be a problem.

Clearly you haven't looked at the driver from the vendor... :-)

I have acquired an MSI Wind equipped with this device, I have
multiple variations of the vendor driver to support the hardware, and
I have a datasheet the covers at least some of the hardware involved.
I'm working on it...

John
--=20
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
