Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40292 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2ELTRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 May 2012 15:17:33 -0400
Received: by bkcji2 with SMTP id ji2so2955058bkc.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 May 2012 12:17:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336658913-11396-1-git-send-email-victorg@ti.com>
References: <1336658913-11396-1-git-send-email-victorg@ti.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Sat, 12 May 2012 22:17:16 +0300
Message-ID: <CA+XVXfcw+9vJ3pixC79DyQA25JmrpgC-m+PPohSdyUmLMe9Zig@mail.gmail.com> (sfid-20120512_211740_853260_11C208F8)
Subject: Re: [PATCH v2] wl12xx: fix fm_coex parameters configuration
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, coelho@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2012 at 5:08 PM, Victor Goldenshtein <victorg@ti.com> wrote:
> Wrong fm_coex parameters were set during wl12xx
> init phase, fix it.
>
> Signed-off-by: Ziv Riesel <zivriesel@ti.com>
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---
>
> v2: changed the subject wlcore -> wl12xx

Are you sure this is not relevant for 18xx? Are the parameters there correct?

Arik
