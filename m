Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48009 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab1JEAmX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 20:42:23 -0400
Received: by qadb15 with SMTP id b15so844624qad.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 17:42:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317726707-23497-3-git-send-email-hauke@hauke-m.de>
References: <1317726707-23497-1-git-send-email-hauke@hauke-m.de> <1317726707-23497-3-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 4 Oct 2011 17:42:02 -0700
Message-ID: <CAB=NE6WFVnu+MB7uh_Np=Z6E93b75dZLVa9xcjwx8a25qbJFJQ@mail.gmail.com> (sfid-20111005_024228_258568_2018B5C7)
Subject: Re: [PATCH 3/3] compat: add linux/of.h just when CONFIG_OF is set.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 4, 2011 at 4:11 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> In kernel < 2.6.34 linux/of.h unconditionally includes asm/prom.h which
> is not available on all architectures. In newer kernel versions this is
> just included if CONFIG_OF is set. For these old kernel just include
> linux/of.h when CONFIG_OF is set. This fixes a compile problem with
> ath6kl as it uses linux/of.h only when CONFIG_OF is set.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied and pushed all 5 patches, thanks!

  Luis
