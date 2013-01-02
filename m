Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3ABNTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 08:19:52 -0500
Message-ID: <1357132813.9839.21.camel@jlt4.sipsolutions.net> (sfid-20130102_141954_551859_2C0942BE)
Subject: Re: wireless regression with 3.7 on MSI MS-1013 notebook
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 02 Jan 2013 14:20:13 +0100
In-Reply-To: <50E42DBF.7070206@web.de> (sfid-20130102_141003_824152_0268C4BC)
References: <50E42DBF.7070206@web.de> (sfid-20130102_141003_824152_0268C4BC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-02 at 13:53 +0100, Jörg-Volker Peetz wrote:

>    WARNING: at net/wireless/core.c:389 wiphy_register+0x5c0/0x600 [cfg80211]()


> and the module rt2500pci fails to load.

This issue was introduced by Gertjan's commit
55d2e9da744ba11eae900b4bfc2da72eace3c1e1 and subsequently fixed by
Helmut's patch f5685ba675449b072feab6a5391a9ef9f604bc94 which is already
on the stable track.

johannes

