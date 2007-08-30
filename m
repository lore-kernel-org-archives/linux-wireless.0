Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4088 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbXH3NPU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 09:15:20 -0400
Date: Thu, 30 Aug 2007 08:38:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] Net: ath5k, split hw into hw, phy and initvals
Message-ID: <20070830123849.GB5140@tuxdriver.com>
References: <2713029743177393055@pripojeni.net> <20070828171034.GB29343@infradead.org> <40f31dec0708291850j2d35db6cu9de7c5f0a91e76f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0708291850j2d35db6cu9de7c5f0a91e76f7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 30, 2007 at 04:50:01AM +0300, Nick Kossifidis wrote:
> 2007/8/28, Christoph Hellwig <hch@infradead.org>:

> > ath5k_hw_phy.o should probably be ath5k_phy.o by conventions used by
> > most drivers and ath5k_hw_inivals.o mights aswell be something like
> > ath5k_init.o

> If you check out the code you'll see i'm using the same convention
> inside them, ath5k_hw* files contain hw related functions
> (ath5k_hw_<name>) while driver code has ath5k_<name>. Also ath5k_init
> is misleading, file acually includes initial register settings for

I have to agree w/ Christoph -- the extra "_hw" in the names is just
a bit unwieldy.

John

P.S.  "ath5k_initvals.c" seems acceptable to me.
-- 
John W. Linville
linville@tuxdriver.com
