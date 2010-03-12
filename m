Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61831 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab0CLGco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 01:32:44 -0500
Received: by bwz1 with SMTP id 1so762019bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 22:32:43 -0800 (PST)
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 1/4] wl1251: make local symbols static
References: <1268322276-16640-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 12 Mar 2010 08:32:40 +0200
In-Reply-To: <1268322276-16640-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Thu\, 11 Mar 2010 17\:44\:36 +0200")
Message-ID: <87zl2ecanr.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> Make local functions and data static, also constify
> some structures. While at it, clean up unneeded includes.
>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> Cc: Bob Copeland <me@bobcopeland.com>

Thanks. Looks good, but...

> -#include <linux/mod_devicetable.h>

...this is needed for struct sdio_device_id AFAICS. If you can send a
new version which keeps that include, you'll have my acked-by.

-- 
Kalle Valo
