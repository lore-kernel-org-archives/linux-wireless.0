Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38927 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0FGRqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 13:46:03 -0400
Received: by gye5 with SMTP id 5so2421431gye.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jun 2010 10:46:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006071633.49820.holgerschurig@gmail.com>
References: <201006071633.49820.holgerschurig@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 7 Jun 2010 10:45:39 -0700
Message-ID: <AANLkTilE-pbxqcYCz0TeZZfnjQbiD0ycATKaC9sHHMcZ@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix function pointer check
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 7, 2010 at 7:33 AM, Holger Schurig <holgerschurig@gmail.com> wrote:
> This makes "iw wlan0 dump survey" work again with
> mac80211-based drivers that support it, e.g. ath5k.
>
> Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

Is this a stable fix?

  Luis
