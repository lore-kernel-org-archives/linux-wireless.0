Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60278 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab0GLPaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 11:30:46 -0400
Received: by pwi5 with SMTP id 5so1848795pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jul 2010 08:30:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1278879791-12646-1-git-send-email-hauke@hauke-m.de>
References: <1278879791-12646-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 12 Jul 2010 08:30:16 -0700
Message-ID: <AANLkTimLweydYTbS-O6Q2sX-W0H5z7cWOLUqQphSTO1s@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: fix build of ath5k for CONFIG_PM_SLEEP=n
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	philipp_subx@redfish-solutions.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 11, 2010 at 1:23 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> suspend and resume are activated in ath5k if CONFIG_PM_SLEEP is set and
> not if just CONFIG_PM is set.
>
> This should fix the problems reported by Philip Prindeville.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks! Applied and pushed out, at noon we'll have a new tarball with this.

  Luis
