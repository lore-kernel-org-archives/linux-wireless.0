Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fb05-06.mta.terra.com.br ([200.154.152.95]:43228 "EHLO
	fb05-06.mta.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYLPER2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 23:17:28 -0500
Received: from sr01-10.mta.terra.com.br (sr01-10.mta.terra.com.br [200.154.152.29])
	by quadra.hst.terra.com.br (Postfix) with ESMTP id BA8762560CD6
	for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 00:55:51 -0300 (BRT)
Message-ID: <4947261E.1060906@unitednerds.org> (sfid-20081216_051732_127601_3AFE4927)
Date: Tue, 16 Dec 2008 01:53:02 -0200
From: Piter PUNK <piterpunk@unitednerds.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>,
	Jason Self <jason.self@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Realtek wireless 8187se
References: <b76df900812151329x4309b264u7a017e4b4c2d8451@mail.gmail.com> <69e28c910812151355l6549e8c2mea381a12663c7cb5@mail.gmail.com> <20081216012603.GA27773@tuxdriver.com>
In-Reply-To: <20081216012603.GA27773@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Mon, Dec 15, 2008 at 10:55:29PM +0100, Stefanik G=E1bor wrote:
>=20
>> Looks like this is a MiniPCIE card, so the chip is essentially an
>> RTL8187 or RTL8187B with the USB communication part replaced with a
>> PCI Express one. Given the existence of this open-source driver,
>> adding support for it into rtl818x should not really be a problem.
>=20
> Clearly you haven't looked at the driver from the vendor... :-)
>=20
> I have acquired an MSI Wind equipped with this device, I have
> multiple variations of the vendor driver to support the hardware, and
> I have a datasheet the covers at least some of the hardware involved.
> I'm working on it...

If you have it in any useful form, i'll be very happy testing it
on my machine with 8187SE. Is an "OEM" MSI Wind (Positivo Mobo
White 1050), the wireless is working fine with the vendor driver
rtl8187se_linux_26.1023.1118.2008 and kernel 2.6.27.x, but is
very better to have the driver merged in kernel.

Good luck to all of us -:)

Piter PUNK
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
