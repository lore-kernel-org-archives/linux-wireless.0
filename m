Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:40540 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005Ab1DMSej (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 14:34:39 -0400
To: "John W. Linville" <linville@tuxdriver.com>
Cc: sedat.dilek@gmail.com, Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2 1/7] ath5k: optimize tx descriptor setup
References: <1302453139-11437-1-git-send-email-nbd@openwrt.org>
	<1302646041-3917-1-git-send-email-nbd@openwrt.org>
	<BANLkTingC8r-obXeYxjbHVr2G80MCbhyMQ@mail.gmail.com>
	<20110413125134.GA4832@tuxdriver.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 13 Apr 2011 21:34:35 +0300
In-Reply-To: <20110413125134.GA4832@tuxdriver.com> (John W. Linville's message of "Wed\, 13 Apr 2011 08\:51\:34 -0400")
Message-ID: <87fwpmknk4.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

>> Looks like this v2 did not found its way to wireless-next [1].
>
> That's what happens, when it is posted after I've already merged the v1. :-)
>
> I fixed things up and will commit the difference with the following message:
>
>     ath5k: improve comments for optimized tx descriptor setup
>     
>     Comment the use of local variables to reduce the number of load/store
>     operations on uncached memory, in hopes of not losing this optimization
>     accidentally in the future.

Thanks John. It was my fault as I was so slow to comment. But I blame
the sun for this, it's so amazing to see the sun again after six
months! ;)

-- 
Kalle Valo
