Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37917 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbbEOOoi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 10:44:38 -0400
Received: by wicnf17 with SMTP id nf17so139869692wic.1
        for <linux-wireless@vger.kernel.org>; Fri, 15 May 2015 07:44:37 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAGRGNgWbmWCmKUN8gGEJ4eQSMd8QW8M9ij0_kK8jv3HpS1df0Q@mail.gmail.com>
References: <1431693340-8861-1-git-send-email-linux@rempel-privat.de>
	<CAGRGNgWbmWCmKUN8gGEJ4eQSMd8QW8M9ij0_kK8jv3HpS1df0Q@mail.gmail.com>
Date: Fri, 15 May 2015 16:44:37 +0200
Message-ID: <CA+icZUXYEqzjkC=u1njYqRreDr3SKDokgE=D1SGOr+rcj-B4Ug@mail.gmail.com> (sfid-20150515_164451_653377_863CE9D9)
Subject: Re: [PATCH] ath9k: add phy.c
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 15, 2015 at 4:38 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Oleksij,
>
> On Fri, May 15, 2015 at 10:35 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
>> ... and move dup code from ar5008_phy.c and ar9002_phy.c to phy.c
>
> A better subject might be:
>
> ath9k: consolidate common phy functions
>
> "phy.c" doesn't really mean anything to people outside the developers
> of this particular driver.
>

Jupp.

Is a consolidation also possible/wise/doable also for phy.h?
( I see this snippet in your new phy.c file... )
...
+#include "phy.h"
+#include "ar9002_phy.h"
...

IOW, can ar9002_phy.h move into phy.h?

- sed@ -
