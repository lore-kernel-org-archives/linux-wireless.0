Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55535 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZIONAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 09:00:30 -0400
Date: Tue, 15 Sep 2009 08:57:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Thomas Ilnseher <illth@gmx.de>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH3]Add analog switch support
Message-ID: <20090915125734.GA2651@tuxdriver.com>
References: <1252956934.4696.23.camel@luzifer.localnet> <69e28c910909141243i5551c87bsfd0c9e767cfa254@mail.gmail.com> <1252958183.4696.25.camel@luzifer.localnet> <4AAEA510.5060606@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4AAEA510.5060606@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 14, 2009 at 03:18:24PM -0500, Larry Finger wrote:
> Thomas Ilnseher wrote:
> > On Mo, 2009-09-14 at 21:43 +0200, Gábor Stefanik wrote:
> >> Always send patches to John Linville, and CC linux-wireless.
> > Ok, the last try ...
> > 
> > As I've seen Gàbor's patch, I noticed that my previous patch was
> > bullshit. This patch should work:
> > 
> > (see: http://bcm-v4.sipsolutions.net/802.11/PHY/Anacore)
> > 
> > Signed-off-by: Thomas Ilnseher <illth@gmx.de>
> > 
> 
> A few points about patch formatting.
> 
> The subject of the submittal message should be of the form "[PATCH]
> component: Description". For this one, something like "[PATCH] b43:
> Add LP PHY analog switch support" would be appropriate. If multiple
> versions are needed, indicate that a previous one is superceded by
> [PATCH V2] ..., etc.
> 
> There should be a line containing --- after the last signed-off-by line.
> 
> Anything between the beginning of the e-mail and the --- line becomes
> part of the permanent record if the patch is accepted. Usually quoted
> material and words like bullshit are avoided. Not always, but usually.
> 
> Between the --- line and the start of the patch, you can place
> instructions to Linville regarding the circumstances of the patch and
> its priority. Such directions are useful to distinguish an improvement
> that should wait for the next merge period from a bug fix that should
> be sent upstream ASAP. In this case, the patch fixes a system crash on
> some platforms and should be applied now.

Above is a good summary.  I usually refer people here (which has
mostly the same information):

	http://linux.yyz.us/patch-format.html

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
