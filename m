Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36388 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab1FETX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 15:23:26 -0400
Received: by gxk21 with SMTP id 21so1251113gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Jun 2011 12:23:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=HrP5pSi0t-18N2yGpBueeL2qMSg@mail.gmail.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
	<1306928768-7501-44-git-send-email-rvossen@broadcom.com>
	<BANLkTin1hT2WT40_uozZvtX-PH5aZHqfZg@mail.gmail.com>
	<4DE90DCE.6060207@broadcom.com>
	<BANLkTimQacOURw4wQzkyNizksZZj=nhvfQ@mail.gmail.com>
	<4DEB3FF3.8090904@broadcom.com>
	<BANLkTi=HrP5pSi0t-18N2yGpBueeL2qMSg@mail.gmail.com>
Date: Sun, 5 Jun 2011 20:23:25 +0100
Message-ID: <BANLkTin9S-Fv=HGA5QBs9=tMvfN5K3VpNw@mail.gmail.com> (sfid-20110605_212329_740672_CD235784)
Subject: Re: [PATCH 44/83] staging: brcm80211: replaced typedef si_t with
 struct si_pub
From: julie Sullivan <kernelmail.jms@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> #include <dngl_stats.h>
>
> #include <dhd.h>
> #include <linux/ieee80211.h>
> -typedef const struct si_pub si_t;
> +
> +struct si_pub;
>
> #include <dngl_stats.h>
> #include <dhd.h>

Is there any reason why dngl_stats.h and dhd.h are included twice in wl_iw.c?

(if not, maybe you corrected this in another patch, I couldn't get the
series to apply cleanly so there was no easy way of checking. If so
sorry for the noise)

Cheers
Julie
