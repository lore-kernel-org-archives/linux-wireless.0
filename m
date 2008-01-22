Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3203 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbYAVPCA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 10:02:00 -0500
Date: Tue, 22 Jan 2008 09:54:32 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-davem' branch of wireless-2.6
	(2008-01-21)
Message-ID: <20080122145432.GB3206@tuxdriver.com> (sfid-20080122_150205_025841_B98D790A)
References: <20080121202835.GA3065@tuxdriver.com> <200801220856.55024.hs4233@mail.mn-solutions.de> <20080122125400.596ccbeb@morte> <20080122145126.GA3206@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080122145126.GA3206@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 22, 2008 at 09:51:26AM -0500, John W. Linville wrote:
> On Tue, Jan 22, 2008 at 12:54:00PM +0100, Stefano Brivio wrote:
> > On Tue, 22 Jan 2008 08:56:54 +0100
> > Holger Schurig <hs4233@mail.mn-solutions.de> wrote:
> > 
> > > > Holger Schurig (5):
> > > >       libertas cs/sdio: fix 'NOHZ: local_softirq_pending 08'
> > > 
> > > This patch was originally from Marc Pignat <marc.pignat@hevs.ch>. 
> > > Should I have made an "Author: " line into the patch then I 
> > > re-wrote the patch for wireless-2.6/everything ?
> > 
> > In that case, you should add a "From:" line.
> 
> Yes, sorry for any mixup.  If forwarding a patch authored by someone
> else then please add:
> 
> From: Patch Author <patch.author@email.net>
> 
> ...as the first line of the message.  Or state that someone else is
> the author clearly in the email.

I found the original patch in my records.  Looking at it now I can
see what was intended, but I guess it wasn't clear enough for me to
see then.

If you'll try to follow the "From: " convention above I'll try to
watch more carefully for anomalies like this...deal? :-)

John
-- 
John W. Linville
linville@tuxdriver.com
