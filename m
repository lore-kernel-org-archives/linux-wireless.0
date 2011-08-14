Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48188 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1HNCjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 22:39:52 -0400
Received: by gya6 with SMTP id 6so2698584gya.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 19:39:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=O5fWb6P=WdVQF64vk+j--pmsnQzV158Bfi2i2rPDJ6w@mail.gmail.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
	<CAJ-Vmo=yP7q33FBwDCCnu3f+=E6ONuLK+xj6ye-26bSW_kgtdQ@mail.gmail.com>
	<20110813184140.GC16149@vmraj-lnx.users.atheros.com>
	<CAJ-Vmo=O5fWb6P=WdVQF64vk+j--pmsnQzV158Bfi2i2rPDJ6w@mail.gmail.com>
Date: Sun, 14 Aug 2011 10:39:51 +0800
Message-ID: <CAJ-VmomsHZGy3oU65oXk1kAhrbXKuVNvLJdPjGn8UyEdYF6_iA@mail.gmail.com> (sfid-20110814_043956_630008_E62DE4CD)
Subject: Re: [PATCH 01/11] ath9k_hw: Fix exceed transmission burst-time of 5GHz
From: Adrian Chadd <adrian@freebsd.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 August 2011 10:39, Adrian Chadd <adrian@freebsd.org> wrote:

> Ah, makes sense now. Well, we (collectively) should likely figure out
> how to teach the rate control and TX code how to not exceed TXOP in
> general.
> Do packets that exceed TXOP get marked as filtered?

.. when the relevant bit in AR_PCU_MISCMODE is enabled, that is?
(Obviously they're not being filtered now..)



Adrian
