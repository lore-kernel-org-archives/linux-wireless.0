Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592Ab3GJL3N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 07:29:13 -0400
Date: Wed, 10 Jul 2013 13:31:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Eric Valette <Eric.Valette@Free.fr>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ralink 3290: still lots of misc errors reported by Iwconfig with
 3.10 + HD streaming on WiFi fails
Message-ID: <20130710113158.GA3887@redhat.com> (sfid-20130710_132916_147472_57AAA4E2)
References: <51DBEB0C.6040704@Free.fr>
 <20130709142202.GB3681@redhat.com>
 <51DC1F9D.7000705@Free.fr>
 <51DC259D.9010505@Free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51DC259D.9010505@Free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 09, 2013 at 05:00:45PM +0200, Eric Valette wrote:
> On 07/09/2013 04:35 PM, Eric Valette wrote:
> 
> >>Do you mean that 3.10 perform better than 3.9.9 ? I do not see any
> >>rt2x00 fixes between 3.9 and 3.10 that are not yet applied on 3.9.9.
> >>I can see only some cleanups and new hardware support patches.
> >
> > From memory I think I had a lot of reported TX error with 3.9.9 and
> >they are now gone with 3.10 but the number of misc error reported by
> >iwconfig is still high with 3.10. But you are right the fix for TX is
> >still in wireless git and does not seem to be in 3.10. As I checked
> >several git trees I mist have been confused...
> 
> Unless I'm really tired, this patch is in 3.10 and not in 3.9.9 :
> 
> http://git.kernel.org/cgit/linux/kernel/git/linville/wireless-testing.git/patch/drivers/net/wireless/rt2x00?id=8857d6dc77e4e3afeee2f33c49597010130ed858

You have right, I missed that one. It's on 3.10 but not on 3.9. We could
post it to 3.9 -stable, but since 3.10 is now realised, 3.9 will become
end of life probably.

Stanislaw
