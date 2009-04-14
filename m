Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbZDNL6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 07:58:44 -0400
Date: Tue, 14 Apr 2009 07:58:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath: add module information
Message-ID: <20090414115843.GA6219@infradead.org> (sfid-20090414_135848_032641_E580562A)
References: <200904132244.24122.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200904132244.24122.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +static int __init ath_init(void)
> +{
> +	return 0;
> +}
> +module_init(ath_init);
> +
> +static void __exit ath_exit(void)
> +{
> +}
> +module_exit(ath_exit);

No need for these.

