Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:57866 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1HXOHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 10:07:10 -0400
Received: by iye16 with SMTP id 16so2159855iye.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 07:07:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314184839-13279-2-git-send-email-hauke@hauke-m.de>
References: <1314184839-13279-1-git-send-email-hauke@hauke-m.de> <1314184839-13279-2-git-send-email-hauke@hauke-m.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 25 Aug 2011 00:06:50 +1000
Message-ID: <CAGRGNgX7=A=kRqSoxDNhW2hZSMip=oZd-gy5pWCZekN2jUpG2Q@mail.gmail.com> (sfid-20110824_160714_318027_BDA566AA)
Subject: Re: [PATCH 2/3] compat: add cordic lib
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: mcgrof@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke,

On Wed, Aug 24, 2011 at 21:20, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> compat/cordic.c was copied from lib/cordic.c and include/linux/cordic.h was
> copied from include/linux/cordic.h

Stupid question: If we have a full kernel tree available to update
compat, can't we just copy these files from there?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
