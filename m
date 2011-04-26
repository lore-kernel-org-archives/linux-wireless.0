Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50021 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957Ab1DZV5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 17:57:31 -0400
Received: by iwn34 with SMTP id 34so886193iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 14:57:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303854584-12297-1-git-send-email-hauke@hauke-m.de>
References: <1303854584-12297-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 26 Apr 2011 14:57:11 -0700
Message-ID: <BANLkTikpNrQkNSt46MMSK3a9BAaFfw-wRA@mail.gmail.com> (sfid-20110426_235734_938543_001C60F1)
Subject: Re: [PATCH] compat-wireless: fix compile problem with IRQF_ONESHOT
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 26, 2011 at 2:49 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> IRQF_ONESHOT was introduced in kernel 2.6.32 and wl12xx uses it.
> This patch reverts back to the old behavior when older kernels are used.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, thanks!

  Luis
