Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37092 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab1FAXWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 19:22:36 -0400
Received: by iyb14 with SMTP id 14so231986iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 16:22:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306928768-7501-54-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com> <1306928768-7501-54-git-send-email-rvossen@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 2 Jun 2011 09:22:15 +1000
Message-ID: <BANLkTimFNLgUf8bOps7bWFVfYzOMzvWEcA@mail.gmail.com> (sfid-20110602_012242_493831_F7DDFAFF)
Subject: Re: [PATCH 54/83] staging: brcm80211: combine sbsdpcmdev.h and sbsdio.h
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 1, 2011 at 21:45, Roland Vossen <rvossen@broadcom.com> wrote:
> From: Franky Lin <frankyl@broadcom.com>
>
> Combine two head files both for sdio sb configuration in fullmac
>
> Signed-off-by: Franky Lin <frankyl@broadcom.com>
> Reviewed-by: Roland Vossen <rvossen@broadcom.com>
> Reviewed-by: Arend van Spriel <arend@broadcom.com>

You might want to mention the typedef removal in the description of
this and the other similar patches.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
