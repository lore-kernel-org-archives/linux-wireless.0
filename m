Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54585 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab1FAXiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 19:38:13 -0400
Received: by iwn34 with SMTP id 34so247850iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 16:38:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306928768-7501-50-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com> <1306928768-7501-50-git-send-email-rvossen@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 2 Jun 2011 09:37:53 +1000
Message-ID: <BANLkTikgGUmRmdXmjgs-cViFr_JzTCVpgA@mail.gmail.com> (sfid-20110602_013817_162398_57DCE60C)
Subject: Re: [PATCH 50/83] staging: brcm80211: absorb bcmcdc.h into dhd_cdc.c
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 1, 2011 at 21:45, Roland Vossen <rvossen@broadcom.com> wrote:
> From: Franky Lin <frankyl@broadcom.com>
>
> Merge bcmcdc.h into dhd_cdc.c in fullmac as it's only used by
> dhd_cdc.c
>
> Signed-off-by: Franky Lin <frankyl@broadcom.com>
> Reviewed-by: Roland Vossen <rvossen@broadcom.com>
> Reviewed-by: Arend van Spriel <arend@broadcom.com>

Again, you might want to mention the typedef elimination in the description.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
