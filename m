Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63203 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1HVPGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 11:06:14 -0400
Received: by gya6 with SMTP id 6so3625255gya.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 08:06:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313667904-15188-1-git-send-email-hauke@hauke-m.de>
References: <1313667904-15188-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 22 Aug 2011 08:05:54 -0700
Message-ID: <CAB=NE6XPt9=5Mah7mPRWS7pmV1NcqO1U6FB2hf57AfQ8xbdT7Q@mail.gmail.com> (sfid-20110822_170618_700710_5680B595)
Subject: Re: [PATCH] compat-wireless: fix building with CONFIG_CFG80211_INTERNAL_REGDB
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, lists@wildgooses.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 18, 2011 at 4:45 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> When building with CONFIG_CFG80211_INTERNAL_REGDB set there is a db.txt
> and genregdb.awk needed. $(srctree) contains the position of the kernel
> source and not the position of the compat-wireless root directory.
>
> Reported-by: Ed W <lists@wildgooses.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied and pushed, thanks!

 Luis
