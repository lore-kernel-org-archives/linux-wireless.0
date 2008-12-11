Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59050 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164AbYLKUKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 15:10:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 12:10:25 -0800
Subject: Re: [PATCH] ath9k: Do not remove header padding on RX from short
 frames
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	Patrick McHardy <kaber@trash.net>
In-Reply-To: <b6c5339f0812111149h6f243682t9a34691f80b4cfe5@mail.gmail.com>
References: <20081211162213.GA28193@jm.kir.nu>
	 <b6c5339f0812111149h6f243682t9a34691f80b4cfe5@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 11 Dec 2008 22:10:21 +0200
Message-ID: <1229026221.6240.11.camel@jm-desktop> (sfid-20081211_211030_015614_1FFB6ECF)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-12-11 at 11:49 -0800, Bob Copeland wrote:
> On Thu, Dec 11, 2008 at 11:22 AM, Jouni Malinen
> <jouni.malinen@atheros.com> wrote:
> > The 802.11 header is only padded to 32-bit boundary when the frame has
> > a non-zero length payload.

> Thanks Jouni, that clears up the question of the same code in ath5k
> (http://marc.info/?l=linux-wireless&m=122888546315200&w=2).

Yes, the same rules on 802.11 header padding applies to ath5k.

- Jouni


