Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41928 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab1LOGDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 01:03:38 -0500
Received: by wgbdr13 with SMTP id dr13so3345729wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 22:03:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323871708-19852-1-git-send-email-linville@tuxdriver.com>
References: <1323871708-19852-1-git-send-email-linville@tuxdriver.com>
Date: Thu, 15 Dec 2011 07:03:36 +0100
Message-ID: <CACna6rx2qUeqZFQyujay2cxMNYFb1Q+H3K5NsXyvq=eNoAQMOA@mail.gmail.com> (sfid-20111215_070341_381482_E7C6F331)
Subject: Re: [PATCH] b43: avoid calling bcma_* if CONFIG_B43_BCMA is not set
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/14 John W. Linville <linville@tuxdriver.com>:
> Avoids this:
>
> ERROR: "bcma_chipco_pll_write" [drivers/net/wireless/b43/b43.ko] undefined!

Ouch, sorry. Thanks for patch.

-- 
Rafał
