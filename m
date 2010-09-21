Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42259 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab0IUWVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 18:21:17 -0400
Received: by iwn5 with SMTP id 5so5462791iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Sep 2010 15:21:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285100791-384-2-git-send-email-hauke@hauke-m.de>
References: <1285100791-384-1-git-send-email-hauke@hauke-m.de> <1285100791-384-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 21 Sep 2010 15:20:56 -0700
Message-ID: <AANLkTike5EZUp02Y7bRDn_amQB680+u7KYHHqxwPkcZd@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: fix wl12xx driver
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 21, 2010 at 1:26 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This deactivate the wl1271_sdio driver, because it needs
> wl12xx_platform_data.c directly compiled into the kernel.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied and pushed, thanks!

  Luis
