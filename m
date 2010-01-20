Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:56474 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab0ATTlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 14:41:09 -0500
Received: by pxi12 with SMTP id 12so5892914pxi.33
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2010 11:41:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264015996-30679-1-git-send-email-hauke@hauke-m.de>
References: <1264015996-30679-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 20 Jan 2010 11:40:46 -0800
Message-ID: <43e72e891001201140j5aee5053u3700cdfbb256a001@mail.gmail.com>
Subject: Re: [PATCH] compat: fix build with CONFIG_USB=m
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 20, 2010 at 11:33 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The usb compat code was not build if usb was build as module in kernel.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks a lot, applied and propagated to 2.6.33 stable branch

  Luis
