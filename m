Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36852 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934448AbbEOOjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 10:39:05 -0400
Received: by iepk2 with SMTP id k2so114195225iep.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 May 2015 07:39:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431693340-8861-1-git-send-email-linux@rempel-privat.de>
References: <1431693340-8861-1-git-send-email-linux@rempel-privat.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 16 May 2015 00:38:44 +1000
Message-ID: <CAGRGNgWbmWCmKUN8gGEJ4eQSMd8QW8M9ij0_kK8jv3HpS1df0Q@mail.gmail.com> (sfid-20150515_163916_551953_DE8864E3)
Subject: Re: [PATCH] ath9k: add phy.c
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oleksij,

On Fri, May 15, 2015 at 10:35 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> ... and move dup code from ar5008_phy.c and ar9002_phy.c to phy.c

A better subject might be:

ath9k: consolidate common phy functions

"phy.c" doesn't really mean anything to people outside the developers
of this particular driver.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
