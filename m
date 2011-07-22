Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35442 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab1GVUcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 16:32:39 -0400
Date: Fri, 22 Jul 2011 16:16:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	ralf@linux-mips.org, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org, jonas.gorski@gmail.com, mb@bu3sch.de,
	george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com
Subject: Re: [PATCH v2 00/11] bcma: add support for embedded devices like
 bcm4716
Message-ID: <20110722201637.GC10938@tuxdriver.com> (sfid-20110722_223244_032020_35B38A93)
References: <1310835342-18877-1-git-send-email-hauke@hauke-m.de>
 <CACna6ryjYGuLc5c88eke=gjgwQyVD+A9afM6zCRhqV1THHgWvA@mail.gmail.com>
 <4E2933A0.40200@hauke-m.de>
 <20110722133925.GA10938@tuxdriver.com>
 <4E299189.7080700@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4E299189.7080700@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 22, 2011 at 05:04:41PM +0200, Hauke Mehrtens wrote:
> On 07/22/2011 03:39 PM, John W. Linville wrote:
> > On Fri, Jul 22, 2011 at 10:24:00AM +0200, Hauke Mehrtens wrote:
> >> On 07/22/2011 12:30 AM, Rafał Miłecki wrote:
> >>> 2011/7/16 Hauke Mehrtens <hauke@hauke-m.de>:
> > 
> >>>> @Ralf: Could you please merger this into the mips tree so that it will be in linux-3.1.
> >>>
> >>> ML for bcma is linux-wireless. Should we pass that patches "via" Ralf
> >>> or John? Using linux-wireless (and John's tree) makes more sense to
> >>> me, as we will work on the same tree and will get less merge
> >>> conflicts. However don't take me as Linux development style guru, just
> >>> my POV.
> > 
> >> I talked about this with Florian Fainelli and he said that the patches
> >> should rather pass Ralf then John, but merging would be easier when they
> >> are passing John. I do not have a problem with both solutions and
> >> rebasing it to an other tree is no problem for me.
> >> John and Ralf, who wants to take these patches? ;-)
> > 
> > I don't really care -- I figured Ralf was taking them due to the MIPS arch bits.
> > 
> > John
> 
> Hi John,
> 
> yes because of the MIPS arch bits it should go through Ralf, but there
> are many changes for bcma in wireless-testing and adding my changes to
> mips tree will cause some problems when wireless-testing and mips are
> merged together by Linus.
> 
> Hauke

I'm happy to take them if Ralf agrees.  You'll need to repost them
(or at least send them to me again).

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
