Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2246 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbYBUUcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 15:32:07 -0500
Date: Thu, 21 Feb 2008 15:18:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ahmed Ammar <b33fc0d3@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: b43 (H/W 4306 Rev. 03)
Message-ID: <20080221201811.GM3094@tuxdriver.com> (sfid-20080221_203213_050705_7EA2B117)
References: <84ac67910802210444q4da4f02bo2d172493ef2c7158@mail.gmail.com> <20080221163134.GF3094@tuxdriver.com> <84ac67910802211007n55569d6j92dee1da198e9b1d@mail.gmail.com> <20080221182615.GK3094@tuxdriver.com> <84ac67910802211204y575e893cnd056bbd7442f27ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <84ac67910802211204y575e893cnd056bbd7442f27ea@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 21, 2008 at 08:04:28PM +0000, Ahmed Ammar wrote:
> > > Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
> >
> >
> > You are still using the same firmware.
> >
> >  Make sure you extracted the firmware to the right place.  You may have
> >  to use the "-w" option to b43-fwcutter.  The proper firmware location
> >  depends on the distribution.  For Fedora it is in /lib/firmware.
> >
> 
> I am very sure. Do I need to reboot?  All I did was: rmmod b43 ssb

Hmmm...OK, my mistake.

> bonding: bond0: enslaving wlan0 as an active interface with a down link.

This looks a little odd.  Have you had this working in the past?
Can you try a setup using just wlan0 (i.e. without bonding)?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
