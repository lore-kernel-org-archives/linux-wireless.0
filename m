Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48023 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYKFNqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 08:46:09 -0500
Date: Wed, 5 Nov 2008 13:22:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	Wilson Ribeiro <wribjr@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Realtek wireless 8187se
Message-ID: <20081105182224.GC3505@tuxdriver.com> (sfid-20081106_144614_546075_6E7865FF)
References: <740646d0811040501w5571d464u757e05399803f768@mail.gmail.com> <69e28c910811040852u7f3f3481t7bf31ad3af8c03ad@mail.gmail.com> <49108E26.4040205@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <49108E26.4040205@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 04, 2008 at 10:02:14AM -0800, Larry Finger wrote:
> Stefanik G=E1bor wrote:
> >=20
> > Can you check the actual print on the chip itself? "RTL8187L" and
> > "RTL8187B" are supported currently. Also, what is the USB device ID=
 of
> > the chip? 0x8187, 0x8189, 0x8197 and 0x8198 are known to work in th=
e
> > latest preview kernels.
> >=20
>=20
> Both work with 2.6.27.

IIRC, 8187se is a PCI device.

John
--=20
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
