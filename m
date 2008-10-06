Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37385 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYJFG0x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 02:26:53 -0400
Subject: Re: at76_usb driver status
From: Pavel Roskin <proski@gnu.org>
To: Kalle Valo <Kalle.Valo@iki.fi>
Cc: Greg KH <greg@kroah.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <87r66umeyh.fsf@litku.valot.fi>
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com>
	 <20081005061603.GB28533@kroah.com> <87d4ifsgg5.fsf@litku.valot.fi>
	 <1223270894.18180.7.camel@dv> <87vdw6mgdl.fsf@litku.valot.fi>
	 <1223271737.18180.15.camel@dv>  <87r66umeyh.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 02:26:43 -0400
Message-Id: <1223274403.23988.5.camel@dv> (sfid-20081006_082656_915880_5E284FD0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-06 at 09:10 +0300, Kalle Valo wrote:
> Pavel Roskin <proski@gnu.org> writes:
> 
> >> I agree, it's very confusing. I'll change the name of the mac80211
> >> port to something else, most probably to at76c50x-usb. Any comments?
> >> Anyone?
> >
> > I'd rather avoid the old driver completely.  But if we want to resurrect
> > it, its name was "at76c503a".
> 
> The atmel driver says it supports that also that chipset:
> 
> config ATMEL
>       tristate "Atmel at76c50x chipset  802.11b support"
> 
> Hence I would like to have the usb suffix in the name, just to avoid
> the confusion.

We'll get confusion either way, especially if we recover the old driver.

I see almost no interest to the driver after drivers for modern hardware
(like Broadcom, Intel, Ralink) became functional.  The only activity I'm
aware of is in the Red Hat bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=438606

I'm afraid the existing userbase just cannot support two different
drivers.  There are not enough users to test them, report bugs and avoid
being confused by our actions.

-- 
Regards,
Pavel Roskin
