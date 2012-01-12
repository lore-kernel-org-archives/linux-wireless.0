Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56035 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2ALQLv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 11:11:51 -0500
Received: by werm1 with SMTP id m1so1465611wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2012 08:11:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1326315180-29398-1-git-send-email-linville@tuxdriver.com>
References: <1326315180-29398-1-git-send-email-linville@tuxdriver.com>
Date: Thu, 12 Jan 2012 17:11:50 +0100
Message-ID: <CACna6rxffpPhYVqKNttu79JET=NkBP4NrAayywQHWcj=mw=T9A@mail.gmail.com> (sfid-20120112_171155_175441_0259BC76)
Subject: Re: [PATCH] b43: add default option to avoid duplicating device
 support with brcmsmac
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/1/11 John W. Linville <linville@tuxdriver.com>:
> +config B43_BCMA_EXTRA
> +       bool "Support for devices also supported by brcmsmac"
> +       depends on B43_BCMA
> +       default n
> +

Is this really *the* solution? I wonder if we can do whatever you're
trying to do in a better way? To let final users try both drivers
without recompiling kernel?

The description also isn't saying too much. I can't imagine anyone
taking decision advisedly other than "n, as it's the default". On
other hand, what should we put here? The whole comparison of drivers?
Can be hard, but I really think there should be more info.

-- 
Rafał
