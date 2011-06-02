Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36308 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759015Ab1FBCpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 22:45:53 -0400
Received: by iyb14 with SMTP id 14so327459iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 19:45:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306928768-7501-71-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com> <1306928768-7501-71-git-send-email-rvossen@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 2 Jun 2011 12:45:32 +1000
Message-ID: <BANLkTimQT7Hqy=_UWr1ZL127NOXgAgvgKQ@mail.gmail.com> (sfid-20110602_044603_245921_FBD71666)
Subject: Re: [PATCH 71/83] staging: brcm80211: further simplified register
 access macro's
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 1, 2011 at 21:45, Roland Vossen <rvossen@broadcom.com> wrote:
> The SELECT_BUS_READ and SELECT_BUS_WRITE macro's always select
> a (sdio) bus operation for fullmac, and a memory operation for
> softmac. Thus they can be removed by expanding them in place.
>
> Signed-off-by: Roland Vossen <rvossen@broadcom.com>
> Reviewed-by: Arend van Spriel <arend@broadcom.com>

As a next step of this cleanup, you might want to turn these into
static inline functions instead of macros.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
