Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45622 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3FFNPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 09:15:11 -0400
Date: Wed, 5 Jun 2013 13:45:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Jakub Kicinski <kubakici@wp.pl>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Incorrect resolution of merge conflict in net/mac80211/iface.c
Message-ID: <20130605174537.GA15004@tuxdriver.com> (sfid-20130606_151516_448330_0283B757)
References: <20130605161445.309a2942@north>
 <CAGXE3d_TRYRA-o0K+zL-76rp0Xsv98bQnOPRJVepAP+iogrsTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d_TRYRA-o0K+zL-76rp0Xsv98bQnOPRJVepAP+iogrsTg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 05, 2013 at 04:37:21PM +0200, Helmut Schaa wrote:
> On Wed, Jun 5, 2013 at 4:14 PM, Jakub Kicinski <kubakici@wp.pl> wrote:
> > Hi John,
> >
> > I'm afraid merge in commit 84e46e17c8 of wireless-testing is
> > not correct.  I don't know how would you like to resolve this
> > technical error, I attach my fixup patch in case it will help
> > you.  You may also want to take a look at commit a0f5d4b3a3
> > of linux-next, I believe Stephen have merged two offending
> > patches correctly there.
> >
> > BTW I think the way MAC addresses of active monitors are
> > handled for devices that use address masks need some work
> > on its own I hope to send a fix for that later this week.
> 
> Indeed, good catch. Stephens merge looks correct to me.

Yep, looks fine -- thanks, Jakub!

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
