Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:53450 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbYEaQui (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2008 12:50:38 -0400
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet
	transmit
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
	linux-kernel@vger.kernel.org
In-Reply-To: <200805311841.46740.mb@bu3sch.de>
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com>
	 <200805311711.16266.mb@bu3sch.de>
	 <69e28c910805310934w7d2bc2ddkec27926a8c8033c4@mail.gmail.com>
	 <200805311841.46740.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 31 May 2008 12:50:36 -0400
Message-Id: <1212252636.2766.10.camel@rd> (sfid-20080531_185041_807977_CFBCD63C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-31 at 18:41 +0200, Michael Buesch wrote:
> On Saturday 31 May 2008 18:34:29 Stefanik G=E1bor wrote:
> > "BUG: unable to handle kernel NULL pointer dereference at 00000004
> > IP: [<f8dd3a99>] :b43:b43_generate_txhdr+0x6a9/0x790
>=20
> So can you put a few printks into the function to see where it derefe=
rences
> a NULL pointer? (or use gdb to lookup the offset).

u8 key_idx =3D info->control.hw_key->hw_key_idx;

info->control.hw_key is NULL.

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
