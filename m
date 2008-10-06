Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:49457 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYJFFjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 01:39:43 -0400
To: Pavel Roskin <proski@gnu.org>
Cc: Greg KH <greg@kroah.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver status
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com>
	<20081005061603.GB28533@kroah.com> <87d4ifsgg5.fsf@litku.valot.fi>
	<1223270894.18180.7.camel@dv>
From: Kalle Valo <Kalle.Valo@iki.fi>
Date: Mon, 06 Oct 2008 08:39:34 +0300
In-Reply-To: <1223270894.18180.7.camel@dv> (Pavel Roskin's message of "Mon\, 06 Oct 2008 01\:28\:14 -0400")
Message-ID: <87vdw6mgdl.fsf@litku.valot.fi> (sfid-20081006_073947_559319_97A007CC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:

> I'm not going to scream, and I'm not sure my opinion really matters, but
> I don't think it's a good idea to have two different drivers under the
> same name in different kernel trees.
>
> My preference is that we give a better exposure to the mac80211 based
> driver, so that potential contributors don't spend time on dead end
> code.

I agree, it's very confusing. I'll change the name of the mac80211
port to something else, most probably to at76c50x-usb. Any comments?
Anyone?

> Finally, I would prefer that my name is not used with either driver.
> The original driver was written by other people.  I just cleaned it up
> and fixed some bugs.

Ok. After I rename the mac80211 port we don't have to use names of
persons anymore.

-- 
Kalle Valo
