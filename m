Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47934 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab2JDRaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 13:30:21 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so595318lbo.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2012 10:30:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349366701-23154-1-git-send-email-sven@narfation.org>
References: <1349366701-23154-1-git-send-email-sven@narfation.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Thu, 4 Oct 2012 10:29:59 -0700
Message-ID: <CAB=NE6XrTVQuAqGqD2wjyjN6ynyfB+yHXqBcAhRgOn=njBpAuA@mail.gmail.com> (sfid-20121004_193033_191443_8C5317CB)
Subject: Re: [PATCH] ath_hw: Use common REG_WRITE parameter order
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 4, 2012 at 9:05 AM, Sven Eckelmann <sven@narfation.org> wrote:
> All defines for REG_WRITE in Atheros wireless drivers use the order "ah",
> "register" and "value". hw.c is the only file using the order "ah", "value" and
> "register". This inconsistent definition can easily lead to implementation
> errors.
>
> Signed-off-by: Sven Eckelmann <sven@narfation.org>

Good catch! But can you resend specifying in your commit log that this
change is a no-op? Also it may help the reader for you to git grep and
show the other REG_WRITE() definitions on the other c files within the
commit log.

  Luis
