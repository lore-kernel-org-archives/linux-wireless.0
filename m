Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f193.google.com ([209.85.222.193]:54233 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab0DFXdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 19:33:14 -0400
Received: by pzk31 with SMTP id 31so507283pzk.33
        for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 16:33:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1270586624-11410-1-git-send-email-hauke@hauke-m.de>
References: <1270586624-11410-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 6 Apr 2010 16:32:54 -0700
Message-ID: <r2j43e72e891004061632jafedafday1635a515a13b501b@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: use wireless_handlers for wext
	functions.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	michael-dev@fami-braun.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 6, 2010 at 1:43 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The struct wiphy changes in kernel versions so old kernels compiled with
> a different version of struct wiphy than compat-wireless are unable to
> dereference the pointer to the functions in cfg80211_wext_handler
> correctly. This causes oops on kernel >= 2.6.33 when using wext with
> cfg80211.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

thanks applied
