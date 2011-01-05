Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58321 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1AEUJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 15:09:10 -0500
Received: by qyk12 with SMTP id 12so17766470qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 12:09:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294257239.12561.12.camel@Joe-Laptop>
References: <1294255328-14322-1-git-send-email-linville@tuxdriver.com>
	<1294256409.12561.8.camel@Joe-Laptop>
	<AANLkTi=v3oHGiQjASQqChmmsXHuv=UF17_A9XdeFeFNR@mail.gmail.com>
	<1294257239.12561.12.camel@Joe-Laptop>
Date: Wed, 5 Jan 2011 15:09:09 -0500
Message-ID: <AANLkTinN2Ctehx-Lop7jm+jdR7Q3bTaY6EhbSdg7zBe_@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/3] ath5k: move nohwcrypt to ath_common structure
From: Bob Copeland <me@bobcopeland.com>
To: Joe Perches <joe@perches.com>
Cc: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 5, 2011 at 2:53 PM, Joe Perches <joe@perches.com> wrote:
>
> bool is OK.
>

Yes, I was agreeing, just pointing out (for my own benefit, I guess) that
the old rule of using int for bool modparams no longer holds.

-- 
Bob Copeland %% www.bobcopeland.com
