Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54874 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab0KEV0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 17:26:11 -0400
Received: by iwn41 with SMTP id 41so1339710iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Nov 2010 14:26:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288985223-30264-2-git-send-email-hauke@hauke-m.de>
References: <1288985223-30264-1-git-send-email-hauke@hauke-m.de> <1288985223-30264-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 5 Nov 2010 14:25:51 -0700
Message-ID: <AANLkTi=Be22X4UY5xvHD141J_3zEcy4-OiTPPA5a5ZpN@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat: remove unnecessary ifdefs and empty file
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 5, 2010 at 12:27 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The Makefile only builds the needed compat-2.6.XX.c files and not all,
> so the ifdefs are not needed.
>
> compat-2.6.30.c did not had any real content so remove it.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied and pushed.

  Luis
