Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0021.hostedemail.com ([216.40.44.21]:44276 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750725AbcCSEKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2016 00:10:07 -0400
Message-ID: <1458360598.26915.41.camel@perches.com> (sfid-20160319_051034_874849_8E05A0C9)
Subject: Re: [PATCH] staging: refresh TODO for rtl8723au
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linux Driver Project Developer List
	<driverdev-devel@linuxdriverproject.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Date: Fri, 18 Mar 2016 21:09:58 -0700
In-Reply-To: <wrfjbn6bi0f9.fsf@redhat.com>
References: <1458321324-16906-1-git-send-email-xose.vazquez@gmail.com>
	 <wrfjlh5fk7i4.fsf@redhat.com> <1458325693.26915.23.camel@perches.com>
	 <wrfjbn6bi0f9.fsf@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-03-18 at 23:58 -0400, Jes Sorensen wrote:
> Joe Perches <joe@perches.com> writes:
> > On Fri, 2016-03-18 at 13:42 -0400, Jes Sorensen wrote:
> > > Xose Vazquez Perez <xose.vazquez@gmail.com> writes:
> > > > 
> > > > People should not waste time and energy working on this staging driver.
> > > > A replacement(rtl8xxxu) using the kernel wireless stack already was merged
> > > > in the 4.3 kernel.
> > []
> > > 
> > > > 
> > > >  drivers/staging/rtl8723au/TODO | 3 +++
> > > Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> > why not git rm drivers/staging/rtl8723au/ ?
> Because you don't just pull the rug out under people. I plan to mark it
> obsolete and then remove it in a follow-on release.

Duh.

I note you removed the obsolete suggestion which
is probably more valuable then updating the TODO.

Updating the TODO to something like:

Actual bug fixes only, no other changes accepted.
This driver is going to be removed by 4.8 or so

is also probably more valuable than keeping all the
current items and just adding a note that another
driver exists.

