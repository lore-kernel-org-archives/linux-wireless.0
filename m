Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43256 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbaHVMmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:42:06 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so10341845wgh.8
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:42:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
References: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 22 Aug 2014 14:42:04 +0200
Message-ID: <CA+BoTQkNsK4m9XGtmgrtQHjLT=erAo9NA66HUEK2E=36xK-51Q@mail.gmail.com> (sfid-20140822_144222_393690_03F529F5)
Subject: Re: [PATCH v2 0/6] ath10k: ath10k: fixes 2014-08-07, part 2
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 August 2014 14:23, Michal Kazior <michal.kazior@tieto.com> wrote:
> Hi,
>
> This is part 2 (of 3) of my patches. Split for
> your reviewing pleasure.
>
> This is related to irq handling only. Prepares for
> more start/restart sequences fixes.
>
> v2:
>  * patch [1/6] is from part 1
>  * patch [5/6] is new
>  * some fixes, see notes
>  * based on
>    f2c7cb774e3e0a8152b1134015c245ba0abddfc6 and
>    4 crash dump patches (v8) from Kalle

Forgot to add I also dropped `ath10k: unmask ce irqs after posting rx
buffers` as it didn't really make much sense to swap the order.


Michał
