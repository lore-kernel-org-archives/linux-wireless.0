Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49685 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2LCTBi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 14:01:38 -0500
Date: Mon, 3 Dec 2012 13:59:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@adurom.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH V2 v3.7] brcmsmac: handle packet drop on enqueuing
 correctly
Message-ID: <20121203185914.GH26027@tuxdriver.com> (sfid-20121203_200142_346412_0FDDF991)
References: <1353961396-7061-1-git-send-email-arend@broadcom.com>
 <50BC63E5.9020101@broadcom.com>
 <871uf7w6w0.fsf@purkki.adurom.net>
 <20121203183912.GE26027@tuxdriver.com>
 <50BCF57E.8020204@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50BCF57E.8020204@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 03, 2012 at 07:54:54PM +0100, Arend van Spriel wrote:
> On 12/03/2012 07:39 PM, John W. Linville wrote:
> > On Mon, Dec 03, 2012 at 04:24:31PM +0200, Kalle Valo wrote:
> >> Hi Arend,
> >>
> >> "Arend van Spriel" <arend@broadcom.com> writes:
> >>
> >>> What is keeping you from picking up this patch? Anything I should do?
> >>> This V2 removed the no-op changes in ampdu.c that Seth indicated so...
> >>
> >> Most likely it's too late. Dave already told that that John's previous
> >> pull request might not make it to 3.7.
> > 
> > Yes, that.  Also, given the merge difficulties this creates and the
> > fact that Seth's patch is already queued for 3.8, maybe you should
> > consider sending this for the 3.7 stable series when it opens?
> > 
> > John
> > 
> 
> That was my plan when it would not get in for 3.7.0. I wanted it to go
> to stable anyway as the fix is also needed for 3.6.x stable. Just wanted
> to get it upstream fixed first.
> 
> For 3.8 the fix has been reworked on top of Seth patches and is in
> wireless-next (c4dea35e brcmsmac: handle packet drop during transmit
> correctly). Should I refer to that commit when submitting to stable
> (although it is a slightly different patch).

Yes, I think the stable team will appreciate that.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
