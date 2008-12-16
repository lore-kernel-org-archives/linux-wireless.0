Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:49385 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609AbYLPDA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 22:00:28 -0500
Message-ID: <494719C4.3020507@lwfinger.net> (sfid-20081216_040031_698377_0D45303A)
Date: Mon, 15 Dec 2008 21:00:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>,
	Jason Self <jason.self@gmail.com>,
	linux-wireless@vger.kernel.org,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
Subject: Re: Realtek wireless 8187se
References: <b76df900812151329x4309b264u7a017e4b4c2d8451@mail.gmail.com> <69e28c910812151355l6549e8c2mea381a12663c7cb5@mail.gmail.com> <20081216012603.GA27773@tuxdriver.com>
In-Reply-To: <20081216012603.GA27773@tuxdriver.com>
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Mon, Dec 15, 2008 at 10:55:29PM +0100, Stefanik G=E1bor wrote:
>=20
> Clearly you haven't looked at the driver from the vendor... :-)

I have and I know what you face.

> I have acquired an MSI Wind equipped with this device, I have
> multiple variations of the vendor driver to support the hardware, and
> I have a datasheet the covers at least some of the hardware involved.
> I'm working on it...

When you get ready for testers, add Bernhard Schiffner
<bernhard@schiffner-limbach.de> to your list. I helped him get the vend=
or driver
(release 1014) running on his hardware, and I was working on incorporat=
ing it
into the native code, but I'm glad to abandon that project. I hadn't re=
ally
gotten very far, and debugging would have been awful without the hardwa=
re.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
