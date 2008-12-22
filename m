Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:24569 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbYLVVss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 16:48:48 -0500
Message-ID: <b6c5339f0812221348o411c4fabse2d0138acfb4f87f@mail.gmail.com> (sfid-20081222_224854_212524_C2F693B3)
Date: Mon, 22 Dec 2008 16:48:47 -0500
From: "Bob Copeland" <bcopeland@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [ath5k-devel] ath5k_pci: gain calibration timeout / unable to reset hardware -11
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Soeren Sonnenburg" <kernel@nn7.de>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <49500906.70309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229923913.3886.7.camel@localhost>
	 <20081222125819.7353d172.akpm@linux-foundation.org>
	 <4950087E.3080505@gmail.com> <49500906.70309@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 22, 2008 at 4:39 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>
>> Does the _HW lockup_ happen even with 2.6.28? The lockup should be gone there
>> (with the messages still present).
>
> I see Bob already replied, ignore me, he knows better.

I thought Felix's patch had gone into .28, but in fact it hasn't.
We should probably get it in or queue it for .28.1 -- it's a two
liner that will fix a lot of people's setups.

John, if you're reading, that's 23c401574b16cb2b6d2231ba405ebf85b8c87de5
in wireless-testing.

The lockup can still occur, but it's a lot less frequent with his patch.

-- 
Bob Copeland %% www.bobcopeland.com
