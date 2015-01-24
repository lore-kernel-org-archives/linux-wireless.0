Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:52306 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbAXJ20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 04:28:26 -0500
Received: by mail-pa0-f51.google.com with SMTP id fb1so1998970pad.10
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2015 01:28:26 -0800 (PST)
References: <1422091103-10579-1-git-send-email-hong@topbug.net>
From: Hong Xu <hong@hong.me>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: Re: [PATCH v3] ath9k_htc: Add a module parameter to disable blink
In-reply-to: <1422091103-10579-1-git-send-email-hong@topbug.net>
Date: Sat, 24 Jan 2015 01:28:23 -0800
Message-ID: <87vbjwmsso.fsf@home.hong.me> (sfid-20150124_102830_592497_71776805)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hong Xu <hong@topbug.net> writes:

> Add an option "blink" to enable or disable the LED blink. The default
> value is set to 1 so that existing users would not experience any
> unexpected changes.

Just noticed v2 is applied. Please ignore this patch. I will send a fix
patch later.

Hong
