Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:50571 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYJ2Xkk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 19:40:40 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-10-29
References: <20081029231855.GD3485@tuxdriver.com>
Date: Thu, 30 Oct 2008 00:40:09 +0100
In-Reply-To: <20081029231855.GD3485@tuxdriver.com> (John W. Linville's message
	of "Wed, 29 Oct 2008 19:18:55 -0400")
Message-ID: <87iqrb2co6.fsf@denkblock.local> (sfid-20081030_004045_522765_46895F89)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org> wrote:
> Dave,
>
> Another quick round of fixes intended for 2.6.28...
>
> This includes fixes for bugs 11749 and 11845, fixes a reset-related
> regression in ath5k, fixes a Kconfig-related error for rt2x00, and
> fixes some sparse warnings and a possible buffer overrun in libertas.
> Also, it corrects a spelling error and marks Bob Copeland as an
> ath5k maintainer.
>
> Please let me know if there are problems!
>
> Thanks,
>
> John
>
> ---
>
> Individual patches are available here:
>
> 	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/
>
> ---
>
> The following changes since commit 882716604ecf388b2ff09bc76eb2a752aa9cc76b:
[...]
> Elias Oltmanns (1):
>       ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular

Pity, I just posted a *nicer* version of that patch for 2.6.28-rc2.
Well, it doesn't really matter all that much, I suppose.

Regards,

Elias
