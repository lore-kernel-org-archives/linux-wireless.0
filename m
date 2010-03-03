Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40240 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab0CCERW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 23:17:22 -0500
Received: by pwj8 with SMTP id 8so630115pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 20:17:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19341.56441.523682.509267@gargle.gargle.HOWL>
References: <19339.35501.467215.380773@gargle.gargle.HOWL>
	<19340.54345.580466.373621@gargle.gargle.HOWL> <20100303005220.GJ8069@bombadil.infradead.org>
	<19341.56441.523682.509267@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 2 Mar 2010 20:17:02 -0800
Message-ID: <43e72e891003022017l73226794kd3856f2d9ca0ae2@mail.gmail.com>
Subject: Re: [PATCH 1/7] ath9k: Add common code to lib
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 2, 2010 at 7:50 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Luis R. Rodriguez wrote:
>> Can I trouble you to repost a new series of patches required for
>> ath9k_htc which does not add/use a lib.c and instead stuffs
>> things into common from the start? If there are patches
>> which are cosmetic, can you send them as a second series
>> so that we are clear what stuff is 2.6.34-rc2 material or
>> not?
>
> I sent a mail yesterday to JWL, but forgot to CC the list.
> Here is the series.
>
> To clarify things, these are the pending patches for
> ath9k_htc (in order).
>
> [PATCH 1/3] ath9k_htc: Add ath9k_htc driver
> [PATCH 2/3] ath9k_hw: HW fixes for ath9k_htc
> [PATCH 3/3] ath9k: Fix HW deinit
>
> [PATCH 1/2] ath9k: Fix symbol collision between ath9k and ath9k_htc
> [PATCH 2/2] ath9k_htc: Remove library

Ah thanks. So why remove a library at the end if the driver hasn't
been merged yet, how about just do away with the library from the
start and add the stuff you need to ath9k_htc on the first patch.

  Luis
