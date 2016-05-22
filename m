Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42396 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751383AbcEVGzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2016 02:55:13 -0400
Message-ID: <1463900091.32493.4.camel@coelho.fi> (sfid-20160522_085517_770938_A395AC96)
From: Luca Coelho <luca@coelho.fi>
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>,
	David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 22 May 2016 09:54:51 +0300
In-Reply-To: <CAAA5faFVE+wd5hLFRjeDZNTM1Lg1rCdMRUbYAZiVEH_yJNqa6A@mail.gmail.com>
References: <87eg8yfc8b.fsf@kamboji.qca.qualcomm.com>
	 <20160520.194148.1467687685270353684.davem@davemloft.net>
	 <CAAA5faFVE+wd5hLFRjeDZNTM1Lg1rCdMRUbYAZiVEH_yJNqa6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: wireless-drivers-next 2016-05-13 (take two)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-05-21 at 20:25 -0600, Reinoud Koornstra wrote:
> On Fri, May 20, 2016 at 5:41 PM, David Miller <davem@davemloft.net>
> wrote:
> > 
> > From: Kalle Valo <kvalo@codeaurora.org>
> > Date: Thu, 19 May 2016 15:45:08 +0300
> > 
> > > 
> > > this the second version of the last pull request to net-next for
> > > 4.7,
> > > which got postponed due to the recent iwlwifi merge conflict. Now
> > > that
> > > Linus fixed the merge problem in his tree I actually didn't have
> > > to fix
> > > anything in my tree anymore. So that's why I still use the same
> > > tag as
> > > in my previous pull request.
> > > 
> > > The only dependency is that you need Linus' iwlwifi fix in your
> > > tree
> > > before you pull this:
> > > 
> > > 0e034f5c4bc4 iwlwifi: fix mis-merge that breaks the driver
> > > 
> > > So if you could pull latest Linus' tree to net-next that would
> > > solve
> > > that. I just did a test merge of that on your net-next tree and
> > > didn't
> > > see any conflicts, so this pull should go smoothly. Also these
> > > patches
> > > have been in linux-next at least a week now. But please let me
> > > know if
> > > you see any issues.
> > Done, pulled, thanks a lot!
> > 
> Forgive my ignorance here, but I cannot find it in 4.6+
> Is this merged in another branch or do I have an issue with my copy
> of 4.6+?
> I am anxious to try it out.

You'll only see it in "4.6+" (actually the current merge window for
4.7) once Linus pull from net.  This is the full merge flow from
iwlwifi into the mainline:

iwlwifi -> wireless-drivers -> net -> linux.git

--
Cheers,
Luca.
