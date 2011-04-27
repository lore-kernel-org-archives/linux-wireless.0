Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35145 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab1D0SIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 14:08:41 -0400
Received: by iyb14 with SMTP id 14so1566629iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 11:08:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303927259-6983-1-git-send-email-hauke@hauke-m.de>
References: <1303927259-6983-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 27 Apr 2011 11:08:20 -0700
Message-ID: <BANLkTinWevTH3x38t49Rw6jhOx0qc4jYpg@mail.gmail.com> (sfid-20110427_200845_568334_D57632D0)
Subject: Re: [PATCH] compat-wireless: backport multicast filter in p54 for
 kernel < 2.6.35
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 27, 2011 at 11:00 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The interface changed with kernel 2.6.35 and we have to backport these changes.
>
> CC: Christian Lamparter <chunkeey@googlemail.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied and pushed, thanks!

  Luis
