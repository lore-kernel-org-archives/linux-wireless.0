Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:45197 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYH1MSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 08:18:40 -0400
Subject: Re: [PATCH 06/11] iwlwifi: fix apm_stop
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, Zhu Yi <yi.zhu@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>
In-Reply-To: <1ba2fa240808280441v2a1f1014t52c4bacf69f901af@mail.gmail.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219926807.6064.17.camel@californication>
	 <200808281338.46894.mb@bu3sch.de>
	 <1ba2fa240808280441v2a1f1014t52c4bacf69f901af@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 16:18:38 +0200
Message-Id: <1219933118.6064.76.camel@californication> (sfid-20080828_141902_381878_A41FEC1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> > The patch fixes CSR_GP_CNTRL_REG_FLAG_INIT_DONE was set instead of
> >> > cleared which disabled moving device to D0U state.
> >>
> >> when was this mistake introduced. Is it a regression compared to what we
> >> have in 2.6.26?
> >
> > I think you are overstretching the regression-fixes-only rule a little bit...
> > It will help nobody, if we don't fix actual _bugs_ and push such fixes
> > into the next merge window.
> >
> > Our goal is to have a stable kernel on release. We don't get to that goal, if
> > we defer bugfixes to the next merge window.
> 
> Oh, good I have friends after all :)

this is not about that and you don't have to convince me to get these
patches included. The line of command is John -> Dave -> Linus. I
mentioned it in the other email, that I don't see any problem with these
patches at all. They look all good, but the question here is if they are
suitable for -rc4 or not.

If we keep sending bug fixes that are no clear regression after -rc4,
then we likely have -rc5, -rc6, -rc7 and more. Instead -rc5 could have
been the last. Linus point was clear here. After the merge window it
goes to regression fixing with the goal to release the next kernel
quickly.

Personally I would take all patches, but if I would be in the position
to explain them to Linus, I would reject them. Just see this review as
Linus asking the trick question why he should take it.

Regards

Marcel


