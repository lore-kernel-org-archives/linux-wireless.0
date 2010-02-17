Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:36297 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083Ab0BQGQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 01:16:11 -0500
Date: Wed, 17 Feb 2010 08:15:23 +0200
From: Jouni Malinen <j@w1.fi>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: Bob Copeland <me@bobcopeland.com>, jirislaby@gmail.com,
	mickflemm@gmail.com, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Fix TX/RX padding for all frames
Message-ID: <20100217061523.GA5147@jm.kir.nu>
References: <1266190577-2423-1-git-send-email-benoit.papillault@free.fr>
 <b6c5339f1002151215y4c7d2f33yfd32916e0500b55c@mail.gmail.com>
 <4B79C565.1050701@free.fr>
 <20100216004717.GA6844@hash.localnet>
 <4B7B027D.70701@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B7B027D.70701@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 16, 2010 at 09:39:25PM +0100, Benoit PAPILLAULT wrote:
> I don't have an ath5k based card at hand. I will try to grab one and
> will give an example of said frame. Basically, I followed the same
> strategy for ath9k already.

Are you saying that this patch has not actually been tested at all on
ath5k and it was just based on the changes you did for ath9k? If that is
the case, I would suggest running the tests before actually applying
this. We should really not depend on undocumented hardware behavior to
remain the same between different revisions. That's why I did not like
the changes in ath9k and would not exactly like extending that to even
more different chips taken into account that none of this is needed for
normal use of the card.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
