Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58209 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1LOLqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 06:46:00 -0500
Received: by wgbdr13 with SMTP id dr13so3929925wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 03:45:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323871708-19852-1-git-send-email-linville@tuxdriver.com>
References: <1323871708-19852-1-git-send-email-linville@tuxdriver.com>
Date: Thu, 15 Dec 2011 12:45:58 +0100
Message-ID: <CACna6rwEfgxMcM1FQDLTWqsM3iy2NqokSAByU13oeT-XkysSzw@mail.gmail.com> (sfid-20111215_124603_640466_FEE92E18)
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
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

[BTW] Can you use b43-dev as CC in the future?

-- 
Rafał
