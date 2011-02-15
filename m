Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 124-197-1-37.callplus.net.nz ([124.197.1.37]:36162 "EHLO
	elm.torus.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab1BOWFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 17:05:46 -0500
Message-ID: <4D5AF8B5.10100@davenport.net.nz>
Date: Wed, 16 Feb 2011 11:05:41 +1300
From: Hugh Davenport <hugh@davenport.net.nz>
MIME-Version: 1.0
To: =?UTF-8?B?0J3QuNC60L7Qu9Cw0Lkg0JvQtdC00L7QstGB0LrQuNGF?=
	<nledovskikh@gmail.com>
CC: linville@tuxdriver.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: Use mips generic dma-mapping functions
 to avoid seqfault on AHB chips
References: <AANLkTinqN4MjWz4y5D195f9J8vob42GsG9u39xX-RuJf@mail.gmail.com>
In-Reply-To: <AANLkTinqN4MjWz4y5D195f9J8vob42GsG9u39xX-RuJf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 16/02/11 03:29, Николай Ледовских wrote:
> This patch fixes seqfault on ar2316 and other AHB based chips.
> 

This could fix the issues I have been having with my ubiquiti bullet 2.
It segfaults all the time :P

Cheers,

Hugh
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJNWvi1AAoJEBwrtoQ2Ia06JfUIAIMAYYjFp5n1081UfEQ8BUhJ
3QZiwEleuND+OKGOyCUbA+Ua6Pq9FOZRwpKmPus1p94a3PI5e5hVBtYVgNE+ENJg
M4S7Rc7YPCIGie3OdjztdIR9rscWzV7Z8s1MUt/cFrUqlncIfRE5bpDe8qboXjX8
uSpelqP7EAE6QlS7bKRc40t2ysInPgjsHNURr1uoUkhprsYrxsIvVM9oZtWcqkFq
9GwW/+81cEUS8+d04xrEuF4Upu/9mcP3POFGaCmesdnRPl16ZrSNfK53Fc08v6rG
pT2oYknuUSzFBRl9NBsjwOaZkYVifGvRWpWBLvhMv4og3ylEOw2qtksVFFnRvgc=
=buhf
-----END PGP SIGNATURE-----
