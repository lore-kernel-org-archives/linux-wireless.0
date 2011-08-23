Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39629 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840Ab1HWVdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 17:33:46 -0400
Date: Tue, 23 Aug 2011 14:30:13 -0700
From: Greg KH <greg@kroah.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Greg KH <gregkh@suse.de>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless & staging trees related)
Message-ID: <20110823213013.GC3679@kroah.com> (sfid-20110823_233350_870346_8408A5E0)
References: <20110811155529.e5f47afa0504c4ddef58ab37@canb.auug.org.au>
 <4E438D56.5020801@qca.qualcomm.com>
 <20110811141604.GA14763@suse.de>
 <4E43FA61.1010301@qca.qualcomm.com>
 <20110812121216.28e6979b44bacb651849640b@canb.auug.org.au>
 <20110812135101.GA2286@tuxdriver.com>
 <4E453502.4000401@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E453502.4000401@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2011 at 05:13:22PM +0300, Kalle Valo wrote:
> On 08/12/2011 04:51 PM, John W. Linville wrote:
> > On Fri, Aug 12, 2011 at 12:12:16PM +1000, Stephen Rothwell wrote:
> >> On Thu, 11 Aug 2011 18:50:57 +0300 Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> >>>
> >>> Yes, please delete ath6kl from staging for the 3.2 release as the
> >>> cleanup version is now in wireless-next.
> >>>
> >>> Thank you everyone and sorry for the mess.
> >>
> >> I think that the removal should be done in the wirelesss tree so that
> >> Linus' tree is not broken during the next merge window.
> >>
> >> I have added the removal patch as a merge fixup one the merge of the
> >> wireless tree for today.
> > 
> > Makes sense to me -- probably also is more sane if there is some fool
> > out there relying on the ath6kl driver in staging that doesn't know
> > about the switch to the wireless tree.
> 
> Ok, I'll send a patch to John which removes the staging driver.

Note, I also applied this to the staging-next tree to keep people from
sending me cleanup patches against the driver.  git will resolve the
fact that it was deleted in both branches just fine when we merge with
Linus for 3.2.

thanks,

greg k-h
