Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37659 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622Ab0EMLi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 07:38:58 -0400
Received: by fxm6 with SMTP id 6so227239fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 04:38:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273749396-3199-1-git-send-email-gwingerde@gmail.com>
References: <1273749396-3199-1-git-send-email-gwingerde@gmail.com>
Date: Thu, 13 May 2010 13:38:56 +0200
Message-ID: <AANLkTinoI0ti1hadiqzicDyGX_V7pCcjVH5i2ZWifm2n@mail.gmail.com>
Subject: Re: [PATCH v3 04/10] rt2x00: Move rt2x00debug_dump_frame declaration
	to rt2x00.h.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 13, 2010 at 1:16 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> This allows rt2x00debug_dump_frame to be used from everywhere.
>
> This is preparation for beacon writing clean ups.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Thanks!

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
