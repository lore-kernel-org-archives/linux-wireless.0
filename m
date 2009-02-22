Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:48029 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZBVT1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 14:27:44 -0500
Message-ID: <49A1A72A.50102@gmail.com> (sfid-20090222_202748_809116_A20CEAFC)
Date: Sun, 22 Feb 2009 20:27:38 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, Bob Copeland <me@bob>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <20090222171032.GD6003@nowhere>
In-Reply-To: <20090222171032.GD6003@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22.2.2009 18:10, Frederic Weisbecker wrote:
> I have some troubles with kmemcheck, so I give up for now.
> Well, by reading the kmemcheck documentation, it tells that there can be some false
> positives so...

This has nothing to do with kmemcheck.

> Since we are not sure this is a real bug, I'm not sure it would be interesting.

There is no false positive possibility with these checkers, so this is 
pretty much interesting, because it is a bug.
