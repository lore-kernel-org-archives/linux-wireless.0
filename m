Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:53255 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702Ab0LSOnt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Dec 2010 09:43:49 -0500
Date: Sun, 19 Dec 2010 16:43:47 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Dave Kilroy <kilroyd@googlemail.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] orinoco_cs: fix too early irq request
In-Reply-To: <AANLkTikmtWhSXn6-rFH6ABhSh3soO8jDfomAg9SGe3xX@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1012191642230.28552@math.ut.ee>
References: <alpine.SOC.1.00.1012180014390.26257@math.ut.ee> <AANLkTikmtWhSXn6-rFH6ABhSh3soO8jDfomAg9SGe3xX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Thanks Meelis. An equivalent patch has already been merged in Linus'
> v2.6.37-rc6 (229bd792b), and wireless-next.

Oops, I tested with 2.6.37-rc4-something when I thought I was testing 
the lastest git.

> Does that version also work for you?

Yes, tested with 2.6.37-rc6-00093 and it works fine.

-- 
Meelis Roos (mroos@linux.ee)
