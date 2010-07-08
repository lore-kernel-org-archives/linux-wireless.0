Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58022 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0GHVSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 17:18:08 -0400
Received: by pvc7 with SMTP id 7so480548pvc.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jul 2010 14:18:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1278623518-18964-1-git-send-email-hauke@hauke-m.de>
References: <1278623518-18964-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 8 Jul 2010 14:17:46 -0700
Message-ID: <AANLkTikdSMwgSU8zoC_NtVGC96Wq_Jd-hVkA-D8Rd6wJ@mail.gmail.com>
Subject: Re: [PATCH] compat: fix tracpoint building
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 8, 2010 at 2:11 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> trace/define_trace.h can be included more often and it have to.
>
> This fixes some errors like this:
> WARNING: "__tracepoint_iwlwifi_dev_rx" [/home/hauke/compat-wireless/compat-wireless-git/drivers/net/wireless/iwlwifi/iwlcore.ko] undefined!
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied and pushed new tarball out.

  Luis
