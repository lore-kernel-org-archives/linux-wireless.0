Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbbKGRZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2015 12:25:33 -0500
Date: Sat, 7 Nov 2015 09:25:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: patch "ath10k: drop probe responses when too many are queued"
 added to staging-testing
Message-ID: <20151107172532.GA26631@kroah.com> (sfid-20151107_182546_959827_BF807F76)
References: <14468483293347@kroah.com>
 <87mvuq9p2v.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87mvuq9p2v.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 07, 2015 at 10:43:52AM +0200, Kalle Valo wrote:
> Hi Greg,
> 
> <gregkh@linuxfoundation.org> writes:
> 
> > This is a note to let you know that I've just added the patch titled
> >
> >     ath10k: drop probe responses when too many are queued
> >
> > to my staging git tree which can be found at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> > in the staging-testing branch.
> >
> > The patch will show up in the next release of the linux-next tree
> > (usually sometime within the next 24 hours during the week.)
> >
> > The patch will be merged to the staging-next branch sometime soon,
> > after it passes testing, and the merge window is open.
> >
> > If you have any questions about this process, please let me know.
> 
> Did you apply this and the few other ath10k patches to staging by
> mistake? I had already applied them to my ath.git tree and linus already
> has them:
> 
> 7b7da0a02192 ath10k: drop probe responses when too many are queued

Yeah, sorry about that, my script went wrong when I merged in Linus's
latest tree into my branch.  Sorry for the noise.

greg k-h
