Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isis.lip6.fr ([132.227.60.2]:54671 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbaEZP44 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 11:56:56 -0400
Date: Mon, 26 May 2014 17:57:45 +0200
From: Benoit Taine <benoit.taine@lip6.fr>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/18] staging: rtl8723au: Use kmemdup instead of kmalloc
 + memcpy
Message-ID: <20140526155528.GA29520@lip6.fr> (sfid-20140526_175715_409334_A1739D04)
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
 <1401117687-28911-10-git-send-email-benoit.taine@lip6.fr>
 <wrfjy4xo35qm.fsf@ultrasam.lan.trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <wrfjy4xo35qm.fsf@ultrasam.lan.trained-monkey.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/05/2014 17:43, Jes Sorensen wrote:
> Benoit Taine <benoit.taine@lip6.fr> writes:
> > This issue was reported by coccicheck using the semantic patch 
> > at scripts/coccinelle/api/memdup.cocci
> >
> > Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
> > ---
> > Tested by compilation without errors.
> >
> >  drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c |    3 +--
> >  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c |   16 ++++++----------
> >  2 files changed, 7 insertions(+), 12 deletions(-)
> 
> Benoit,
> 
> I believe this was already applied to staging-next - if you feel
> something is missing. Could you please re-diff against the latest
> staging-next tree.

Agreed, it is mostly 80 chars per line compliance. I will resend.

-- 
Benoît Taine
Master cycle intern
Regal Team. LIP6
