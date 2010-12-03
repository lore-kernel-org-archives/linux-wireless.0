Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33859 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0LCVSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 16:18:35 -0500
Received: by iwn6 with SMTP id 6so325927iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Dec 2010 13:18:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291403269-2938-1-git-send-email-hauke@hauke-m.de>
References: <1291403269-2938-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 3 Dec 2010 13:18:14 -0800
Message-ID: <AANLkTikpJnmDHo7h78b9Qajt5gAok7E+i3TwPk9pZ4QV@mail.gmail.com>
Subject: Re: [PATCH 1/2] compat-wireless: make patches apply again.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 3, 2010 at 11:07 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> These patches are applying now, but crap/0002-ath9k-tlog-support.patch
> does not apply any more, some more changes have to be done to make it
> work again.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

I applied both but I had some issues with the patches as I forgot to
push out changes. I adjusted them and hacked up a different change for
the packet log patch, it was a bit odd.

Applied and pushed, thanks!

  Luis
