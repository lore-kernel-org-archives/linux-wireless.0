Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:50209 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab0FUTB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 15:01:58 -0400
Received: by pxi12 with SMTP id 12so1506850pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 12:01:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277027097-3222-1-git-send-email-fercerpav@gmail.com>
References: <1277027097-3222-1-git-send-email-fercerpav@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 21 Jun 2010 12:01:37 -0700
Message-ID: <AANLkTinBQ_kRnG1cFw_0ChawRfYpXa5u0Zsr2k4_IdKS@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: fix compilation for 2.6.32
To: Paul Fertser <fercerpav@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 20, 2010 at 2:44 AM, Paul Fertser <fercerpav@gmail.com> wrote:
> 2.6.32 was the latest version using CONFIG_WIRELESS_EXT. Without this patch
> compilation produced
>
> net/wireless/wext-compat.c:443: error: ‘struct wireless_dev’ has no member named ‘wext’
>
> since config.mk defined CONFIG_CFG80211_WEXT but autoconf.sh didn't.
>
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>

Awesome thanks, applied and I propagated this to the linux-2.6.35.y branch too.

  Luis
