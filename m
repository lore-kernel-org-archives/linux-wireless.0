Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:45743 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbYBXX1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 18:27:33 -0500
Received: by an-out-0708.google.com with SMTP id d31so314539and.103
        for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2008 15:27:32 -0800 (PST)
Message-ID: <40f31dec0802241527p8263572t67bd9a9c64ae5d4@mail.gmail.com> (sfid-20080224_232736_398059_CDA38CA1)
Date: Mon, 25 Feb 2008 01:27:32 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com, "Bob Copeland" <me@bobcopeland.com>
In-Reply-To: <20080224201719.GB20715@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224042851.GE4426@makis.domain.invalid>
	 <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
	 <20080224201719.GB20715@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/24, Christoph Hellwig <hch@infradead.org>:
> On Sun, Feb 24, 2008 at 06:45:33AM +0200, Nick Kossifidis wrote:
>
> > Sorry, forgot to CC Bob...
>  >
>  > Bob can you test this on your 5242 (together with the next patch) and
>  > see what happens ?
>
>
> Talking about unsupported chips.  My MacBook Pro has a AR5418, do you
>  guys need any kind of help for this chip, e.g. mmio traces?
>

I've got a MacBook pro myself, we'll work on AR5416/8 sometime in the
future but we have other things to fix first (e.g. AR5212/5213 +
RF5111/5112/2112 can reach up to 27Mbit/s while 5413/2413 only go as
far as 13Mbit/s with ath5k). Thanx for the offer, i'll keep you posted
if we need anything ;-)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
