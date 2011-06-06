Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1291 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab1FFJLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:11:05 -0400
Message-ID: <4DEC999B.4000204@broadcom.com> (sfid-20110606_111110_001703_7A89AE07)
Date: Mon, 6 Jun 2011 11:10:51 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "julie Sullivan" <kernelmail.jms@gmail.com>
cc: "Julian Calaby" <julian.calaby@gmail.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 44/83] staging: brcm80211: replaced typedef si_t
 with struct si_pub
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-44-git-send-email-rvossen@broadcom.com>
 <BANLkTin1hT2WT40_uozZvtX-PH5aZHqfZg@mail.gmail.com>
 <4DE90DCE.6060207@broadcom.com>
 <BANLkTimQacOURw4wQzkyNizksZZj=nhvfQ@mail.gmail.com>
 <4DEB3FF3.8090904@broadcom.com>
 <BANLkTi=HrP5pSi0t-18N2yGpBueeL2qMSg@mail.gmail.com>
 <BANLkTin9S-Fv=HGA5QBs9=tMvfN5K3VpNw@mail.gmail.com>
In-Reply-To: <BANLkTin9S-Fv=HGA5QBs9=tMvfN5K3VpNw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julie,

> Is there any reason why dngl_stats.h and dhd.h are included twice in wl_iw.c?
>
> (if not, maybe you corrected this in another patch, I couldn't get the
> series to apply cleanly so there was no easy way of checking. If so
> sorry for the noise)

In addition to Henry's answer: I just created a commit that fixes any 
double header issues. This commit will appear in a future patch series 
(so not as a repost of the current patch series), if that is ok with you.

Thanks for noticing this,

Roland.

