Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2927 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbXGSSc7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 14:32:59 -0400
Date: Thu, 19 Jul 2007 14:24:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: STA reassociation improvements
Message-ID: <20070719182440.GA6603@tuxdriver.com>
References: <20070715140251.B4F6B7B409F@zog.reactivated.net> <20070716185616.58030016@griffin.suse.cz> <469C2644.3060701@gentoo.org> <20070717113838.03561c26@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070717113838.03561c26@logostar.upir.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 17, 2007 at 11:38:38AM +0200, Jiri Benc wrote:
> On Mon, 16 Jul 2007 22:15:32 -0400, Daniel Drake wrote:
> > Jiri Benc wrote:
> > > [removed netdev, no reason for sending this there]
> > 
> > Was I wrong for sending the patch there, or was it just your ACK that 
> > you didn't think would be relevant on netdev?
> 
> linux-wireless mailinglist was created to lower traffic at netdev. I
> understand that in the way that wireless patches should be sent to
> linux-wireless only; they will be sent to nedev by John when he's asking
> for a pull. But I'm not sure about that (Cc:ing John), my comment was more
> about my ack.

I think linux-wireless is sufficient, especially for small and/or
isolated patches.  But there is no real harm in including netdev,
especially for patches with broader impact.  For example, if Zhu Yi
and PJ had chosen to push the multiqueue stuff on wireless first then
it would certainly have been appropriate to copy netdev.  I guess
it is just a judgment call -- if your patch merits broader review,
then copy netdev as well.

Hth!  (I doubt if it does!)

John
-- 
John W. Linville
linville@tuxdriver.com
