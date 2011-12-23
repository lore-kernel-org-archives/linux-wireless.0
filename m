Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49206 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1LWPBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 10:01:17 -0500
Received: by iaeh11 with SMTP id h11so15211818iae.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 07:01:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324630694.2182.325.camel@cumari>
References: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
 <1324586850-5212-3-git-send-email-hauke@hauke-m.de> <1324630694.2182.325.camel@cumari>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 23 Dec 2011 07:00:56 -0800
Message-ID: <CAB=NE6X=yTDgLdGeR5ZzRW5qEmZkdyk2JC4LQ72RNYkq=iGMCw@mail.gmail.com> (sfid-20111223_160121_234168_B0DE90FB)
Subject: Re: [PATCH 2/6] compat-wireless: remove platform_device_id for kernel
 < 2.6.30
To: Luciano Coelho <coelho@ti.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 23, 2011 at 12:58 AM, Luciano Coelho <coelho@ti.com> wrote:
> The question is, should we even bother compiling wl12xx if the kernel is
> < .30?

You would know better, what systems would even have the driver, etc. I
welcome such patch. For now I'll apply this series.

  Luis
