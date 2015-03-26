Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34128 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbbCZStB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 14:49:01 -0400
Date: Thu, 26 Mar 2015 18:48:57 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: vnt_rf_setpower: fix missing rate
 RATE_12M
Message-ID: <20150326184856.GB4668@charon.olymp> (sfid-20150326_194905_673487_1D272B47)
References: <1425746197-6614-1-git-send-email-tvboxspy@gmail.com>
 <20150326152213.GA4668@charon.olymp>
 <551450EE.5010700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <551450EE.5010700@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2015 at 06:33:18PM +0000, Malcolm Priestley wrote:
> 
> 
> On 26/03/15 15:22, Luis Henriques wrote:
> >Hi Malcolm,
> >
> >On Sat, Mar 07, 2015 at 04:36:37PM +0000, Malcolm Priestley wrote:
> >>When the driver sets this rate a power of zero value is set causing
> >>data flow stoppage until another rate is tried.
> >>
> >>Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> >>Cc: <stable@vger.kernel.org> # v3.17+
> >
> >Is there a reason for this patch being tagged for stable v3.17+ ?
> Hi Luis
> 
> Sorry I thought it wouldn't apply to 3.16.
> 
> I need to do a backport patch for earlier kernels.
> 

Awesome, thanks for the quick reply.

Commit 163fe301b9f78b6de57d0014eafe504fd20c0cd4 is a clean cherry-pick
to 3.16 kernel, but I haven't check which other kernels it should also
be applied to.

Cheers,
--
Luís

> Regards
> 
> Malcolm
> 

