Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40494 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab1KHU7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 15:59:11 -0500
Received: by iage36 with SMTP id e36so982767iag.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 12:59:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320785191-8052-1-git-send-email-hauke@hauke-m.de>
References: <1320785191-8052-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 8 Nov 2011 12:58:50 -0800
Message-ID: <CAB=NE6XGfCXPvc8jLpPzvBTf-8cwWeKV8uLXuh_-S1MYSCzGsQ@mail.gmail.com> (sfid-20111108_215915_422422_4AB2A236)
Subject: Re: [PATCH] compat: add some workarounds for Debian squeeze
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 8, 2011 at 12:46 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Debian squeeze also backports some stuff and this conflicts with compat
> wireless stuff. This is a nice way of making compat work with debian
> squeeze without breaking normal kernels.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied, and also applied the other two compat.git patches and
the pending compat-wireless patch you had sent. Thanks!!

  Luis
