Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45346 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab0ECX6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 19:58:46 -0400
Received: by pwj9 with SMTP id 9so1516529pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 16:58:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1272915401-7431-1-git-send-email-hauke@hauke-m.de>
References: <1272913838.2607.5.camel@mj> <1272915401-7431-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 3 May 2010 16:58:25 -0700
Message-ID: <y2v43e72e891005031658ha46b52a3s8f89184db59386ba@mail.gmail.com>
Subject: Re: [PATCH v2] compat: backport usb_alloc_coherent() and
	usb_free_coherent()
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	proski@gnu.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 3, 2010 at 12:36 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  v2: Add arguments to define

Thanks applied.

  Luis
