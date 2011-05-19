Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46336 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab1ESVXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 17:23:06 -0400
Received: by iwn34 with SMTP id 34so2530983iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 14:23:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305396027-5864-3-git-send-email-hauke@hauke-m.de>
References: <1305396027-5864-1-git-send-email-hauke@hauke-m.de> <1305396027-5864-3-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 19 May 2011 14:22:45 -0700
Message-ID: <BANLkTi=D6sd=9TteCkqpLfaJAObyndGgzQ@mail.gmail.com> (sfid-20110519_232309_986561_6C3E71B8)
Subject: Re: [PATCH 3/3] compat-wireless: fix building of brcm80211
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 14, 2011 at 11:00 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The Broadcom brcm80211 driver now needs brcmutil.ko. Furthermore the
> config options are now set to m to, most parts are build as module when
> the options are set to m and y. Some options for this driver where at
> the wrong position in config.mk.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, thanks!

  Luis
