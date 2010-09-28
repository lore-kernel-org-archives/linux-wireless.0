Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:48893 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab0I1J13 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 05:27:29 -0400
Subject: Re: [PATCH] MAINTAINERS: Update git url for the wl1271 driver
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <liville@tuxdriver.com>
In-Reply-To: <1285665597-31547-1-git-send-email-luciano.coelho@nokia.com>
References: <1285665597-31547-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 12:27:19 +0300
Message-ID: <1285666039.28270.54.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 11:19 +0200, Coelho Luciano (Nokia-MS/Helsinki)
wrote:
> We are integrating wl1271 commits via a new git tree now and wl1271
> development should be made on top of the new tree.
> 
> Update the repository url accordingly.
> 
> Cc: John W. Linville <liville@tuxdriver.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6cb1c75..a130d9f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6321,7 +6321,7 @@ WL1271 WIRELESS DRIVER
>  M:	Luciano Coelho <luciano.coelho@nokia.com>
>  L:	linux-wireless@vger.kernel.org
>  W:	http://wireless.kernel.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> +T:	git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
>  S:	Maintained
>  F:	drivers/net/wireless/wl12xx/wl1271*
>  F:	include/linux/wl12xx.h

John, should you apply this directly or should this go via the wl12xx
tree?

-- 
Cheers,
Luca.

