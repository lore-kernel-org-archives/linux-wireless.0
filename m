Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55565 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614AbZKDS2q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 13:28:46 -0500
MIME-Version: 1.0
In-Reply-To: <20091104173217.28463.23610.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173217.28463.23610.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 19:28:51 +0100
Message-ID: <14add3d10911041028p6ed937a2q8b08551fba61e28f@mail.gmail.com>
Subject: Re: [PATCH 03/41] rt2800usb: fix rt2800usb_rfcsr_read()
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 6:32 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: fix rt2800usb_rfcsr_read()
>
> The driver should write the read request into RF_CSR_CFG register
> and not BBP_CSR_CFG one in rt2800usb_rfcsr_read().
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

I believe this one should go to Linus and net-next a.s.a.p.
