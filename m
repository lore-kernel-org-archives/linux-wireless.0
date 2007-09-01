Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:41370 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXIADM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 23:12:29 -0400
Received: by py-out-1112.google.com with SMTP id u77so3807394pyb
        for <linux-wireless@vger.kernel.org>; Fri, 31 Aug 2007 20:12:28 -0700 (PDT)
Message-ID: <40f31dec0708312012i59bae9a0v1a1fb4b997d7bc72@mail.gmail.com>
Date: Sat, 1 Sep 2007 06:12:28 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/5] Net: ath5k, split hw into hw, phy and initvals
Cc: "Christoph Hellwig" <hch@infradead.org>,
	"Jiri Slaby" <jirislaby@gmail.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20070830123849.GB5140@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2713029743177393055@pripojeni.net>
	 <20070828171034.GB29343@infradead.org>
	 <40f31dec0708291850j2d35db6cu9de7c5f0a91e76f7@mail.gmail.com>
	 <20070830123849.GB5140@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/8/30, John W. Linville <linville@tuxdriver.com>:
> On Thu, Aug 30, 2007 at 04:50:01AM +0300, Nick Kossifidis wrote:
> > 2007/8/28, Christoph Hellwig <hch@infradead.org>:
>
> > > ath5k_hw_phy.o should probably be ath5k_phy.o by conventions used by
> > > most drivers and ath5k_hw_inivals.o mights aswell be something like
> > > ath5k_init.o
>
> > If you check out the code you'll see i'm using the same convention
> > inside them, ath5k_hw* files contain hw related functions
> > (ath5k_hw_<name>) while driver code has ath5k_<name>. Also ath5k_init
> > is misleading, file acually includes initial register settings for
>
> I have to agree w/ Christoph -- the extra "_hw" in the names is just
> a bit unwieldy.
>
> John
>
> P.S.  "ath5k_initvals.c" seems acceptable to me.

ACK, i'll remove _hw ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
