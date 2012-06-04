Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56770 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab2FDGbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 02:31:20 -0400
Received: by yenm10 with SMTP id m10so2775166yen.19
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2012 23:31:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338733814-31438-2-git-send-email-hauke@hauke-m.de>
References: <1338733814-31438-1-git-send-email-hauke@hauke-m.de>
	<1338733814-31438-2-git-send-email-hauke@hauke-m.de>
Date: Mon, 4 Jun 2012 09:31:19 +0300
Message-ID: <CAFub=KQ9qrE=u_nfVXK90o6k_itLjE5bP0LQOymB6cJmQQaA1A@mail.gmail.com> (sfid-20120604_083122_751806_7746C448)
Subject: Re: [Lf_driver_backport] [PATCH 2/2] compat-wireless: update some
 urls to git trees in docs
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> --- a/scripts/admin-update.sh
> +++ b/scripts/admin-update.sh
> @@ -2,21 +2,21 @@
>  #
>  # Copyright 2007, 2008, 2010   Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
>  #
> -# Use this to update compat-wireless-2.6 to the latest
> -# wireless-testing.git tree you have.
> +# Use this to update compat-wireless to the latest
> +# linux-nex.git tree you have.

There's a typo in here, linux-nex.

>  #
> -# Usage: you should have the latest pull of wireless-2.6.git
> -# git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> -# We assume you have it on your ~/devel/wireless-testing/ directory. If you do,
> -# just run this script from the compat-wireless-2.6 directory.
> +# Usage: you should have the latest pull of linux-nex.git

Same typo in here too, :)
