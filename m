Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51045 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab1B1Fve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 00:51:34 -0500
Received: by iyb26 with SMTP id 26so2600189iyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 21:51:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298814885-11894-2-git-send-email-hauke@hauke-m.de>
References: <1298814885-11894-1-git-send-email-hauke@hauke-m.de> <1298814885-11894-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 27 Feb 2011 21:51:14 -0800
Message-ID: <AANLkTineuBqUF4_=fTVBLw+Ni3-jAuMCyJ7WsGhyxJTV@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: do not set blink_set for kernel <= 2.6.24
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 27, 2011 at 5:54 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> blink_set is not available on struct led_classdev in kernel <= 2.6.24.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, and pushed both, thanks!!

  Luis
