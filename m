Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56544 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2BCLDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 06:03:20 -0500
Received: by vbjk17 with SMTP id k17so2448404vbj.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 03:03:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328249924-1766-1-git-send-email-john.li.mediatek@gmail.com>
References: <1328249924-1766-1-git-send-email-john.li.mediatek@gmail.com>
Date: Fri, 3 Feb 2012 12:03:19 +0100
Message-ID: <CAOZOX0UeAp_tRd=WsK8HK4fFjJQ2t_T8hoPKiocDc+5BxgTsOQ@mail.gmail.com> (sfid-20120203_120324_682513_0CAAB573)
Subject: Re: [PATCH] rt2x00:Add RT5372 chipset support and VCO recalibration
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: John Li <john.li.mediatek@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Besides the point from Helmut. I have this small comment to add:

> -       if (rt2x00_rt(rt2x00dev, RT5390))
> +       if (rt2x00_rt(rt2x00dev, RT5390) ||
> +               rt2x00_rt(rt2x00dev, RT5390) ||
> +               rt2x00_rt(rt2x00dev, RT5392))
>                rt2800_bbp_write(rt2x00dev, 86, 0x38);

You're checking for RT5390 twice. :)

Ivo
