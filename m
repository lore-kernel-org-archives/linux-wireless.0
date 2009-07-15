Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:40162 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZGOHNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 03:13:20 -0400
Received: by bwz28 with SMTP id 28so1226415bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 00:13:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090618022524.GC10014@hash.localnet>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	<1244685780-28930-8-git-send-email-me@bobcopeland.com> <20090613132144.6c7783bc@mjolnir.ossman.eu>
	<87bposnmxi.fsf@litku.valot.fi> <20090613220908.271865cd@mjolnir.ossman.eu>
	<20090613205737.GA30439@hash.localnet> <20090618022524.GC10014@hash.localnet>
From: Ohad Ben-Cohen <ohad@bencohen.org>
Date: Wed, 15 Jul 2009 10:12:59 +0300
Message-ID: <bd5b16740907150012j7a687dddr5caee38e26bd9868@mail.gmail.com>
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
To: Bob Copeland <me@bobcopeland.com>
Cc: Pierre Ossman <pierre@ossman.eu>, Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless@vger.kernel.org, san@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob, Pierre,

On Thu, Jun 18, 2009 at 5:25 AM, Bob Copeland <me@bobcopeland.com> wrote:
> +#define SDIO_VENDOR_ID_TI                      0x104c
> +#define SDIO_DEVICE_ID_TI_WL1251               0x9066

I wonder how those values are derived ?

Are they officially registered anywhere ?

Thanks,
Ohad.
