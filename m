Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37878 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1BUVAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 16:00:30 -0500
Date: Mon, 21 Feb 2011 15:48:00 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-next-2.6 2011-02-17
Message-ID: <20110221204759.GL9650@tuxdriver.com>
References: <20110218135956.GA2256@joana>
 <20110221201645.GC2965@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110221201645.GC2965@joana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 21, 2011 at 05:16:45PM -0300, Gustavo F. Padovan wrote:
> Hi John,
> 
> * Gustavo F. Padovan <padovan@profusion.mobi> [2011-02-18 10:59:56 -0300]:
> 
> > Hi John,
> > 
> > Busy times at the Bluetooth subsystem. Here is another big set of patches
> > intended to 2.6.39. ;)
> > 
> > One of the changes is the end of the L2CAP and SCO kernel modules. We just
> > merged them into the main bluetooth.ko module. It really never made sense to
> > have them separated. 
> > 
> > Then we have firmware support to a new Atheros device by Bala Shanmugam.
> > The First set of patches for Bluetooth Low Energy(LE) support, by Ville Tervo.
> > Low Energy is a new Bluetooth radio that will bring many new use cases to the
> > Bluetooth technology. Finally, LE connection update command support by Claudio
> > Takahasi. The rest is just bugs fixes and cleanups. 
> > 
> > Please pull, or let me know any doubts you have. Thanks.
> 
> I saw you had a merge conflict between bluetooth-2.6 and bluetooth-next-2.6
> and I want to apologize for the extra work I caused to you. It was all my
> fault by not testing the merge of the my own trees. It won't happen again. ;)

Cool, thanks!  It wasn't a big deal, but better if I can avoid it! :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
