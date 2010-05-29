Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:43679 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0E2SFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 May 2010 14:05:42 -0400
Received: by pxi18 with SMTP id 18so973372pxi.19
        for <linux-wireless@vger.kernel.org>; Sat, 29 May 2010 11:05:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1275140672-4785-1-git-send-email-hauke@hauke-m.de>
References: <1275140107-4616-3-git-send-email-hauke@hauke-m.de>
	<1275140672-4785-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 29 May 2010 11:05:22 -0700
Message-ID: <AANLkTimshD7WqhsEU7Z_Q_iwzmOT4WziVWi4Fium6aoZ@mail.gmail.com>
Subject: Re: [PATCH 3/3] compat-wireless: run refresh only on last applied
	directory
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 29, 2010 at 6:44 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Running "./scripts/admin-refresh.sh -n -p -c refresh" failed because
> patchRefresh refreshes and applies every patch form the series and
> then  reverse them all. If a patch from the next series in an other
> directory depends on that it will not apply any more.
>
> Now only the last series/directory will be refresh.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

All applied, thanks!

  Luis
