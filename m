Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34852 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1IMNpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 09:45:25 -0400
Date: Tue, 13 Sep 2011 09:44:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, gregkh@suse.de
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
Message-ID: <20110913134406.GD11772@tuxdriver.com> (sfid-20110913_154529_536864_F599D30E)
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
 <CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
 <CAC9WiBi5L7uV=OzYBKs=sdjRr4Xykcd2USQPtPhCsSBLdpW-6g@mail.gmail.com>
 <20110913132844.GB11772@tuxdriver.com>
 <CAC9WiBjOj9+HmprcdKhfj5Y=SpNoKQj=wZfBJzR7fpx9OA+1hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAC9WiBjOj9+HmprcdKhfj5Y=SpNoKQj=wZfBJzR7fpx9OA+1hQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 13, 2011 at 03:37:12PM +0200, Francis Moreau wrote:
> On Tue, Sep 13, 2011 at 3:28 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Tue, Sep 13, 2011 at 09:03:13AM +0200, Francis Moreau wrote:
> >> 2011/9/12 Rafał Miłecki <zajec5@gmail.com>:
> >
> >> > The real solution is to add bcma driver support in brcmsmac and ssb
> >> > driver support in brcmfmac. Then you can always use bcma and:
> >> > 1) If b43 will load and detect unsupported PHY, it will release the BCMA's core
> >> > 2) brcmsmac will be loaded to let it support the core
> >> >
> >>
> >> Thanks for the description.
> >>
> >> But what should be done for the time being (3.1-rc5) ?
> >
> > Turn-off CONFIG_B43_BCMA.
> >
> 
> Does the b43/bcma driver support some cards that the brcmsmac one doesn't ?

Not any BCMA-based ones.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
