Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f202.google.com ([209.85.216.202]:47409 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0BHViX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 16:38:23 -0500
Received: by pxi40 with SMTP id 40so6826113pxi.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 13:38:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265467103-11474-1-git-send-email-tom.leiming@gmail.com>
References: <1265467103-11474-1-git-send-email-tom.leiming@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 8 Feb 2010 13:38:02 -0800
Message-ID: <43e72e891002081338q466d9747p10a61b5e1aca4c6d@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix keycache leak in split tkip case
To: tom.leiming@gmail.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 6, 2010 at 6:38 AM,  <tom.leiming@gmail.com> wrote:
> From: Ming Lei <tom.leiming@gmail.com>
>
> If split tkip key is used, ath_delete_key should delete
> rx key and rx mic key. This patch fixes the leak of hw
> keycache in the case.

Can you please resend with Cc: stable@kernel.org on the commit log entry?

> ---
> The patch is against the latest wireless test tree.
>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

  Luis
