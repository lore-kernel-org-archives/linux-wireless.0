Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51280 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab2FFHDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 03:03:03 -0400
Message-ID: <1338966180.4513.4.camel@jlt3.sipsolutions.net> (sfid-20120606_090315_192637_937163DE)
Subject: Re: [ANN] new wireless stack trees
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 06 Jun 2012 09:03:00 +0200
In-Reply-To: <87sje86i1j.fsf@purkki.adurom.net>
References: <1338898271.4514.38.camel@jlt3.sipsolutions.net>
	 <87sje86i1j.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 10:00 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > Given the amount of work going on in the various wireless stack
> > components, I've decided that I'll reflect my maintainer role also in
> > git trees. I've created new trees and will pick patches for
> >  * mac80211
> >  * cfg80211
> >  * rfkill (if needed)
> >
> > into the new trees
> >  * http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211.git;a=summary
> >  * http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211-next.git;a=summary
> 
> Great!
> 
> > I won't maintain an integration tree like John's wireless-testing,
> > please continue to use his. If merge conflicts make it necessary, I'll
> > resolve them in separate branches etc. and work it out with John.
> 
> So when working on mac80211 or cfg80211 changes you still recommend the
> developer to use wireless-testing, did I understand this correctly?

Most of the time, I probably won't care. You might want to give me hints
as to which tree I should apply the patch to but I'm pretty confident I
can also make that call most of the time :-)

johannes

