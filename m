Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55774 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab1LPVp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 16:45:28 -0500
Date: Fri, 16 Dec 2011 16:33:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: avoid calling bcma_* if CONFIG_B43_BCMA is not set
Message-ID: <20111216213307.GA5396@tuxdriver.com> (sfid-20111216_224531_919985_0F7B2834)
References: <1323871708-19852-1-git-send-email-linville@tuxdriver.com>
 <CACna6rwEfgxMcM1FQDLTWqsM3iy2NqokSAByU13oeT-XkysSzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwEfgxMcM1FQDLTWqsM3iy2NqokSAByU13oeT-XkysSzw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2011 at 12:45:58PM +0100, Rafał Miłecki wrote:
> 2011/12/14 John W. Linville <linville@tuxdriver.com>:
> > Avoids this:
> >
> > ERROR: "bcma_chipco_pll_write" [drivers/net/wireless/b43/b43.ko] undefined!
> >
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> [BTW] Can you use b43-dev as CC in the future?

Maybe you should update the MAINTAINERS entry so that
scripts/get_maintainer.pl will find that?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
