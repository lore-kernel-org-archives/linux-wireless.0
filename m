Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37767 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab1ESVW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 17:22:26 -0400
Received: by iyb14 with SMTP id 14so2434164iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 14:22:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305396027-5864-2-git-send-email-hauke@hauke-m.de>
References: <1305396027-5864-1-git-send-email-hauke@hauke-m.de> <1305396027-5864-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 19 May 2011 14:22:06 -0700
Message-ID: <BANLkTincXvSfMndzGoPkFp9j5-LF93=boQ@mail.gmail.com> (sfid-20110519_232229_742981_4B633426)
Subject: Re: [PATCH 2/3] compat-wireless: set CONFIG_COMPAT_STAGING=m
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 14, 2011 at 11:00 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> If this is set to y and all CONFIG_BRCM* options are set to m it causes build
> failures with kernel version < 2.6.36 as there is nothing build into
> the kernel. Besides compat-wireless does not support build anything
> into the kernel.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

applied, thanks!
