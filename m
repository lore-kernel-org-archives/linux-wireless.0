Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab3JGLri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 07:47:38 -0400
Message-ID: <1381146446.13586.19.camel@jlt4.sipsolutions.net> (sfid-20131007_134741_409324_49E7C1CA)
Subject: Re: [PATCH] iwlwifi: pcie: fix merge damage
From: Johannes Berg <johannes@sipsolutions.net>
To: sedat.dilek@gmail.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Date: Mon, 07 Oct 2013 13:47:26 +0200
In-Reply-To: <CA+icZUVf1A2+-LPEARpOnRShm2BXagtHtw7+SidTs2b_ifV97A@mail.gmail.com> (sfid-20131003_120744_144561_24FF73E9)
References: <1380531766-15384-1-git-send-email-johannes@sipsolutions.net>
	 <1380532074.14467.2.camel@jlt4.sipsolutions.net>
	 <20130930203206.GM10994@tuxdriver.com>
	 <1380612524.14430.0.camel@jlt4.sipsolutions.net>
	 <CA+icZUVf1A2+-LPEARpOnRShm2BXagtHtw7+SidTs2b_ifV97A@mail.gmail.com>
	 (sfid-20131003_120744_144561_24FF73E9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-03 at 12:07 +0200, Sedat Dilek wrote:

> > I believe the merge damage only occurred during merging wireless.git (or
> > one of its upstreams) into wireless-next.git.
> >
> 
> Hmm, this patch applies also for Linux v3.12-rc3+, so you are sure it
> is not for iwlwifi-3.12-fixes?

Ahrg, yes, so it happened in wireless-next *before* wireless-next went
into 3.12-rc1.

John, any idea what to do now? Cherry-pick the patch over to
wireless.git?

johannes

