Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3701 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZFWCTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 22:19:38 -0400
Date: Mon, 22 Jun 2009 22:18:57 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
Message-ID: <20090623021857.GA307@hash.localnet>
References: <87bposnmxi.fsf@litku.valot.fi> <20090613220908.271865cd@mjolnir.ossman.eu> <20090613205737.GA30439@hash.localnet> <20090618022524.GC10014@hash.localnet> <20090619212419.2f3626d7@mjolnir.ossman.eu> <b6c5339f0906191331x6c360d63wec431fc9d35b38c0@mail.gmail.com> <20090621203800.08cb4a2d@mjolnir.ossman.eu> <20090622000512.GA30186@hash.localnet> <20090622080931.66aa51fa@mjolnir.ossman.eu> <20090622081436.24c78984@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090622081436.24c78984@mjolnir.ossman.eu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 22, 2009 at 08:14:36AM +0200, Pierre Ossman wrote:
> SDIO interrupts are level interrupts, not edge. That means that the
> interrupt source needs to be handled before the interrupt routine
> returns or the system will get stuck in a fairly tight loop, rehandling
> the same interrupt over and over again.

Hmm good point, let me look into that.

-- 
Bob Copeland %% www.bobcopeland.com

