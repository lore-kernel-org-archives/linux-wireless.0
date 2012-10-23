Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42348 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab2JWNwX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 09:52:23 -0400
Date: Tue, 23 Oct 2012 15:52:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, hch@lst.de,
	s.L-H@gmx.de
Subject: Re: [PATCH v2 1/4] ar5523: Add main driver file
Message-ID: <20121023135222.GB13388@lst.de> (sfid-20121023_155226_988505_57B026AE)
References: <1350415769-8271-1-git-send-email-pontus.fuchs@gmail.com> <1350415769-8271-2-git-send-email-pontus.fuchs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1350415769-8271-2-git-send-email-pontus.fuchs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> + * Copyright (c) 2006
> + *	Damien Bergamini <damien.bergamini@free.fr>
> + * Copyright (c) 2007
> + *	Christoph Hellwig <hch@lst.de>
> + *
> + * Copyright (c) 2006 Sam Leffler, Errno Consulting
> + * Copyright (c) 2008-2009 Weongyo Jeong <weongyo@freebsd.org>
> + * Copyright (c) 2012 Pontus Fuchs <pontus.fuchs@gmail.com>

Might be worth to use the same style for everyone and put them in chonological
order?

