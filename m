Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:45471 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZGBGQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 02:16:51 -0400
Received: by bwz25 with SMTP id 25so971021bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2009 23:16:54 -0700 (PDT)
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: remove skb->do_not_encrypt from skbuff.c
References: <4a4bd294.Hac6+C1W4gkNIlOX%Larry.Finger@lwfinger.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 02 Jul 2009 09:16:51 +0300
In-Reply-To: <4a4bd294.Hac6+C1W4gkNIlOX%Larry.Finger@lwfinger.net> (Larry Finger's message of "Wed\, 01 Jul 2009 16\:18\:12 -0500")
Message-ID: <87hbxvtxrg.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Commit 38ba8fb67d6be3258a ("net: remove unused skb->do_not_encrypt")
> removed the variable from struct skbuff, but the usage in net/core/skbuff.c
> crept back in, probably in the merge between mainline and wireless-testing.
>
> Signed-off-by: Larry.Finger <Larry.Finger@lwfinger.net>

Tested-by: Kalle Valo <kalle.valo@iki.fi>

> John,
>
> This fixes the build problem I reported earlier.

I had exactly the same error. Thanks for fixing this.

John, try to push this to wireless-testing at your earliest convenience
because this fixes a compilation error.

-- 
Kalle Valo
