Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0147.hostedemail.com ([216.40.44.147]:37949 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756510AbcCRS2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 14:28:18 -0400
Message-ID: <1458325693.26915.23.camel@perches.com> (sfid-20160318_192834_102145_43834950)
Subject: Re: [PATCH] staging: refresh TODO for rtl8723au
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linux Driver Project Developer List
	<driverdev-devel@linuxdriverproject.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Date: Fri, 18 Mar 2016 11:28:13 -0700
In-Reply-To: <wrfjlh5fk7i4.fsf@redhat.com>
References: <1458321324-16906-1-git-send-email-xose.vazquez@gmail.com>
	 <wrfjlh5fk7i4.fsf@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-03-18 at 13:42 -0400, Jes Sorensen wrote:
> Xose Vazquez Perez <xose.vazquez@gmail.com> writes:
> > People should not waste time and energy working on this staging driver.
> > A replacement(rtl8xxxu) using the kernel wireless stack already was merged
> > in the 4.3 kernel.
[]
> >  drivers/staging/rtl8723au/TODO | 3 +++
> Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>

why not git rm drivers/staging/rtl8723au/ ?

How about changing MAINTAINERS from:

STAGING - REALTEK RTL8723U WIRELESS DRIVER
M:	Larry Finger <Larry.Finger@lwfinger.net>
M:	Jes Sorensen <Jes.Sorensen@redhat.com>
L:	linux-wireless@vger.kernel.org
S:	Maintained
F:	drivers/staging/rtl8723au/

to

S:	Obsolete

