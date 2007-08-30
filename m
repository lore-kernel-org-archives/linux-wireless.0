Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:48434 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbXH3I1f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 04:27:35 -0400
Received: from poczta.o2.pl (mx12.go2.pl [193.17.41.142])
	by tur.go2.pl (o2.pl Mailer 2.0.1) with ESMTP id 382C123167D
	for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2007 10:27:33 +0200 (CEST)
Date: Thu, 30 Aug 2007 10:26:53 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: netdev@vger.kernel.org
Cc: Jon Smirl <jonsmirl@gmail.com>,
	"Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/5] Net: ath5k, license is GPLv2
Message-ID: <20070830082652.GA2669@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200708292137.48834.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29-08-2007 21:37, Michael Buesch wrote:
> On Wednesday 29 August 2007 21:33:43 Jon Smirl wrote:
>> What if a patch spans both code that is pure GPL and code imported
>> from BSD, how do you license it?
> 
> I think it's a valid assumption, if we say that the author
> of the patch read the license header of a file and agreed with it.
> So the patch is licensed to whatever the fileheader says. And if
> there's none, it's licensed with the COPYING terms.
> If a patch author likes some other license conditions, he must
> explicitely add them with the patch to the file, saying that this
> and that part have these and those conditions. Of course they must
> be compatible with the original license.
> 

I didn't track this thread from the beginning, so maybe I repeat
somebody's ideas (probably like above), but IMHO: do we have to be
so selfish/pedantic? Can't we sometimes 'donate' a little bit to our
'older' bsd cousins or half-brothers? I think, it could be like this:

- if our changes are minor and authors of these changes don't mind
the file could stay BSD licensed only; plus we ask BSD to let it be
dual licensed (but no big hassle);

- otherwise, we should always distinctly mark all GPL parts.

Regards,
Jarek P.

PS: there is probably some mess with gmail addresses in this thread.
