Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZKIQ5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 11:57:06 -0500
Date: Mon, 9 Nov 2009 14:56:29 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: remove rtl8187se driver because of lack of
 development activities
Message-ID: <20091109145629.3587c9f6@pedra.chehab.org>
In-Reply-To: <200911091731.36861.bzolnier@gmail.com>
References: <200911091731.36861.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bartolomiej,

Em Mon, 9 Nov 2009 17:31:36 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> escreveu:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] Staging: remove rtl8187se driver because of lack of development activities
> 
> This driver hasn't seen any real development activities since early July:
> 
>    257bc86   Staging: rtl8187se: remove unused #include <linu
>    2035beb   param:remove-useless-writable-charp
>    305409a   tree-wide: fix some typos and punctuation in com
>    b881c6c   Staging: fix wireless drivers depends
>    a010a33   Staging: rtl8187se/rtl8192e/rtl8192su: allow mod
>    125b181   staging: Add proper selection of WIRELESS_EXT an
>    b3184e1   Staging: rtl8187se: Fix comment-out-typo
>    b6ac161   Staging: ARRAY_SIZE changes
> 
> so remove it for now.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

This driver has several points in common with rtl8192* drivers. As I'm
currently working on cleaning up rtl8192u and see what can be done to merge the
common code used by all those realtek drivers, I prefer to keep this driver for
more time at the tree.

The issue I'm currently facing is that we should rearrange the drivers/staging/rtl* 
into a common rtl component tree, moving the common components to there. This will
avoid duplicated efforts to cleanup the same code several times, on different
places.

I started working on it this weekend, but I haven't finish it yet.

Cheers,
Mauro
