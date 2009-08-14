Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55882 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZHNMaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 08:30:10 -0400
Date: Fri, 14 Aug 2009 08:19:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Revert commit in ath9k
Message-ID: <20090814121905.GB2650@tuxdriver.com>
References: <19076.56592.101907.186453@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19076.56592.101907.186453@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2009 at 09:12:08AM +0530, Sujith wrote:

> Can you revert the commit - "ath9k: Change DEBUG level for certain interrupts" ?
> This interrupt seems to trigger fairly often and floods the log.
> The driver does seem to work with this message suppressed.
> (which was the original behaviour).
> 
> The actual cause for this bug is still unknown, but until it is
> found and fixed, the earlier behaviour can be retained.
> 
> Sorry for the trouble. :)

OK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
