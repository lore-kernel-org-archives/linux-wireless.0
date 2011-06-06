Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1338 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab1FFBe3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 21:34:29 -0400
Date: Sun, 5 Jun 2011 18:34:11 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "julie Sullivan" <kernelmail.jms@gmail.com>
cc: "Julian Calaby" <julian.calaby@gmail.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 44/83] staging: brcm80211: replaced typedef si_t
 with struct si_pub
Message-ID: <20110606013411.GH9005@broadcom.com> (sfid-20110606_033438_226634_2CF9B2D8)
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-44-git-send-email-rvossen@broadcom.com>
 <BANLkTin1hT2WT40_uozZvtX-PH5aZHqfZg@mail.gmail.com>
 <4DE90DCE.6060207@broadcom.com>
 <BANLkTimQacOURw4wQzkyNizksZZj=nhvfQ@mail.gmail.com>
 <4DEB3FF3.8090904@broadcom.com>
 <BANLkTi=HrP5pSi0t-18N2yGpBueeL2qMSg@mail.gmail.com>
 <BANLkTin9S-Fv=HGA5QBs9=tMvfN5K3VpNw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <BANLkTin9S-Fv=HGA5QBs9=tMvfN5K3VpNw@mail.gmail.com>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 05, 2011 at 12:23:25PM -0700, julie Sullivan wrote:
> >
> > #include <dngl_stats.h>
> >
> > #include <dhd.h>
> > #include <linux/ieee80211.h>
> > -typedef const struct si_pub si_t;
> > +
> > +struct si_pub;
> >
> > #include <dngl_stats.h>
> > #include <dhd.h>
> 
> Is there any reason why dngl_stats.h and dhd.h are included twice in wl_iw.c?

No, no good reason.  The double inclusion seems to have been aournd for quite a
while.  A few others got cleaned up, but this one got missed.

> (if not, maybe you corrected this in another patch, I couldn't get the
> series to apply cleanly so there was no easy way of checking. If so
> sorry for the noise)

Nope, not fixed yet.  We'll get it cleaned up in a subsequent patch.

- Henry


