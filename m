Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34803 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654AbbI2HdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 03:33:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: Make mwifiex_dbg a function, reduce object size
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1441043205.3276.28.camel@perches.com>
To: Joe Perches <joe@perches.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20150929073320.9C61F140BF6@smtp.codeaurora.org> (sfid-20150929_093326_304868_C2935FAE)
Date: Tue, 29 Sep 2015 07:33:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The mwifiex_dbg macro has two tests that could be consolidated
> into a function reducing overall object size ~10KB (~4%).
> 
> So convert the macro into a function.
> 
> $ size drivers/net/wireless/mwifiex/built-in.o* (x86-64 defconfig)
>    text	   data	    bss	    dec	    hex	filename
>  233102	   8628	   4809	 246539	  3c30b	drivers/net/wireless/mwifiex/built-in.o.new
>  243949	   8628	   4809	 257386	  3ed6a	drivers/net/wireless/mwifiex/built-in.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
