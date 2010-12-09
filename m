Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51853 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab0LIA2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 19:28:36 -0500
Received: by gyb11 with SMTP id 11so1063498gyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 16:28:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291853727-7919-1-git-send-email-hauke@hauke-m.de>
References: <1291853727-7919-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 8 Dec 2010 16:28:10 -0800
Message-ID: <AANLkTikTWL5G7P9+epq1SnKRw5PDd_i3q2vXa8s9Zd_B@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: make patches apply again
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 8, 2010 at 4:15 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> uninit is already set in netdev_attach_ops so it is not needed an extra time.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied and pushed, thanks!

  Luis
