Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:14258 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZELU55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 16:57:57 -0400
Received: by rv-out-0506.google.com with SMTP id f9so164225rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 13:57:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242160485-7395-1-git-send-email-hauke@hauke-m.de>
References: <1241727955-2228-1-git-send-email-hauke@hauke-m.de>
	<1242160485-7395-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 12 May 2009 13:57:38 -0700
Message-ID: <43e72e890905121357pb5e27fbl9da0a5b86d2b0254@mail.gmail.com>
Subject: Re: [PATCH v2] compat-2.6: update compat.diff
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	Kalle Valo <kalle.valo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2009 at 1:34 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This will fix the make clean problem reported by Brett D. Ussher.
>
> wl12xx will be removed from Makefile. I do not think wl12xx needs to be integrated,
> because it is not rely widely used.
> If needed it will not be very hard to integrate it.

Thanks so much and sorry for the delay. Just a heads up -- we may want
to eventually enable wl12xx once SDIO support kicks in. Android 1.5 is
on 2.6.27 so it would be a nice treat.

Updated from /home/wireless/wireless-testing, git-describe says:
v2.6.30-rc5-23297-gbf2c6a3
wireless-testing latest tag:
master-2009-05-11
This is compat-release:
master-2009-05-11

  Luis
