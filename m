Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48901 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab1DGRaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 13:30:23 -0400
Date: Thu, 7 Apr 2011 13:13:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Cong Wang <amwang@redhat.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [Patch V2] wireless: remove obsolete ar9170usb driver
Message-ID: <20110407171334.GA9692@tuxdriver.com>
References: <1302086729.3811.14.camel@jlt3.sipsolutions.net>
 <1302162181-24065-1-git-send-email-amwang@redhat.com>
 <201104071056.01191.chunkeey@googlemail.com>
 <4D9D7E7C.4040703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4D9D7E7C.4040703@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 07, 2011 at 05:06:04PM +0800, Cong Wang wrote:
> 于 2011年04月07日 16:56, Christian Lamparter 写道:
> >On Thursday 07 April 2011 09:43:01 Amerigo Wang wrote:
> >>V2: against wireless-next-2.6 and really compile tested.
> >>
> >>AR9170USB is scheduled to be removed in 2.6.40.
> >>
> >>Cc: Christian Lamparter<chunkeey@googlemail.com>
> >>Cc: Johannes Berg<johannes@sipsolutions.net>
> >>Cc: "Luis R. Rodriguez"<lrodriguez@atheros.com>
> >>Cc: "John W. Linville"<linville@tuxdriver.com>
> >>Signed-off-by: WANG Cong<amwang@redhat.com>
> >another duplicate?
> >
> >please see:
> >http://www.spinics.net/lists/linux-wireless/msg66871.html
> >[the patch from last week in case you missed that one too.]
> 
> Ah, I am not in wireless list, so didn't know this.
> Why it is not in wireless-next-2.6?

Because I haven't merged it yet -- it's as simple as that.

Anyone else want to quibble over my schedule???

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
