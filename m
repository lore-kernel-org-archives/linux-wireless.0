Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:58272 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZLKHnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 02:43:12 -0500
MIME-Version: 1.0
In-Reply-To: <20091208073542.GC22204@atheros-laptop>
References: <20091208073542.GC22204@atheros-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 10 Dec 2009 23:42:59 -0800
Message-ID: <43e72e890912102342q478593f3ge162d3b8cddd3f61@mail.gmail.com>
Subject: Re: [PATCH] Added compat-bluetooth to compat-wireless-2.6
To: Bala Shanmugam <sbalashanmugam@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	mcgrof@bombadil.infradead.org, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 7, 2009 at 11:35 PM, Bala Shanmugam
<sbalashanmugam@atheros.com> wrote:
>
> Added compat-bluetooth to compat-wireless-2.6
>
> Added new scripts to load and unload wireless
> and bluetooth modules seperately.
>
> Compat is compiled as separate kernel module as
> both wireless and bluetooth modules require it.
>
> Compat Bluetooth has support to compile latest bluetooth code
> for kernel versions 2.6.27 to 2.6.31.
> Signed-off-by: Bala Shanmugam <sbalashanmugam@atheros.com>

Thanks a lot Bala, applied. I made a few changes now like move some of
the compat hunks that are specific to an actual kernel change to their
respective patches/*.patch file. I nuked the old compat files and
updated compat.git to add all the missing items. Additionally changed
the build process and selection for components but I'll elaborate on
that on another e-mail.

  Luis
