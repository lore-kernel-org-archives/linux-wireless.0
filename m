Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYLTJq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 04:46:58 -0500
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: set mac address in
 =?UTF-8?Q?add=5Finterface?=
MIME-Version: 1.0
Date: Sat, 20 Dec 2008 10:46:39 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?Q?Stefanik_G=C3=A1bor?= <netrolller.3d@gmail.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20081219151036.M48373@bobcopeland.com>
References: <20081118044037.GA18983@hash.localnet> <69e28c910812150747j60cf17d9nc2e24aabb991d2a9@mail.gmail.com> <1229357080.12163.47.camel@localhost.localdomain> <69e28c910812150812h4a316327u67aad1b225262816@mail.gmail.com> <b6c5339f0812150916k521fa7a4l4fc3aa560d08c1db@mail.gmail.com> <b6c5339f0812160658y5ed2ceb4qdbb4b2ddf1fe07a5@mail.gmail.com> (sfid-20081216_155826_911157_CE1A0E9E) <1229439670.4471.41.camel@johannes.berg> <20081219151036.M48373@bobcopeland.com>
Message-ID: <acdcd5985c5286b7936dd776618e4937@localhost>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> So in that case, ath5k definitely should not upload a mac until a normal
> interface is brought up, i.e. we should keep the current functionality?

yes.

> It's interesting that b43 works without a regular interface, by my
reading
> of
> its code the mac is also loaded and cleared at add/remove interface time.

I suspect there's some filtering going wrong.

johannes
