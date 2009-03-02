Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35166 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752652AbZCBXCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 18:02:35 -0500
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Tue, 03 Mar 2009 00:02:32 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <b6c5339f0903021444m1f139f63p374cf41194ac2b62@mail.gmail.com>
Message-ID: <20090302230232.76770@gmx.net> (sfid-20090303_000246_558396_F0E431AA)
MIME-Version: 1.0
References: <20090302222948.76770@gmx.net>
 <b6c5339f0903021444m1f139f63p374cf41194ac2b62@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Set TSF fix
To: Bob Copeland <me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Bob!

> It's in the original so I guess it's ok, but it'd be nice to have a
> version
> without the unnecessary "& 0xffffffff" part. =20

I personally think with the "& 0xffffffff" it's cleaner, because it's t=
ype independent. And the compiler should optimize it out, if the type i=
s really 32 bit wide.

> Also can you use the -p
> option
> to diff in the future?

This is an old patch, I now use git for it.

Regards
Alina

--=20
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
f=FCr nur 17,95 =BF/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
