Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6927 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbYJFF2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 01:28:17 -0400
Subject: Re: at76_usb driver status
From: Pavel Roskin <proski@gnu.org>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Greg KH <greg@kroah.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <87d4ifsgg5.fsf@litku.valot.fi>
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com>
	 <20081005061603.GB28533@kroah.com>  <87d4ifsgg5.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 01:28:14 -0400
Message-Id: <1223270894.18180.7.camel@dv> (sfid-20081006_072822_780624_AD48DDD5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-10-05 at 09:29 +0300, Kalle Valo wrote:

> > So for now, if no one really screams, I'll put Pavel's driver into the
> > drivers/staging/ tree so that users can use their devices.  When your
> > driver is merged, we can merely delete this driver instead.
> >
> > Sound good?
> 
> That sounds very good. User's benefit from this and that's what
> counts.
> 
> BTW, Pavel doesn't have time for at76 anymore. So if you have any
> problems with Pavel's driver in the stating tree, I can help you.

I'm not going to scream, and I'm not sure my opinion really matters, but
I don't think it's a good idea to have two different drivers under the
same name in different kernel trees.

My preference is that we give a better exposure to the mac80211 based
driver, so that potential contributors don't spend time on dead end
code.

Finally, I would prefer that my name is not used with either driver.
The original driver was written by other people.  I just cleaned it up
and fixed some bugs.

-- 
Regards,
Pavel Roskin
