Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4485 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759961AbYBLOb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 09:31:56 -0500
Date: Tue, 12 Feb 2008 08:58:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Budhee Jamaich <budheej@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Kalle Valo <kalle.valo@nokia.com>
Subject: Re: madwifi is not fully open source
Message-ID: <20080212135857.GA3051@tuxdriver.com> (sfid-20080212_143200_210670_8DF4458C)
References: <57314e840802111427i7e8d00capbe430727faff78a1@mail.gmail.com> <1202770112.6824.35.camel@localhost.localdomain> <57314e840802120045h6e6960d8jde5657da8aff0e3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57314e840802120045h6e6960d8jde5657da8aff0e3e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 12, 2008 at 10:45:40AM +0200, Budhee Jamaich wrote:

> First - thank you for the detailed response!

Yes, thanks Dan!

> So even if a vendor is willng to completely Open Source it's code,
> having FCC troubles
> is a serious problem.

The answer of course is "it depends".  For example, depending on the
device it might be possible to provide code to configure the device
in "good" ways without necessarily revealing how to configure it in
"bad" ways...YMMV.  This may be more or less difficult depending on
the exact details of your hardware design.

> Is there any vendor who walked this path ? complete Open Source RF code ?
> If yes, has it's chip got FCC certified ?

The rtl8180 driver does not use any firmware and is completely open
source.  The driver code contains lots of "magic number" tables related
to initializing and configuring the device.  I don't know enough
about the hardware to tell you if the hardware is flexible enough
to be easily forced into non-compliant power or frequency settings,
so I can't really characterize the risk to Realtek.

I do know that Realtek supported rtl8180 driver development with
datasheets and access to developers.  Presumably they feel that
whatever risk there is is acceptable to their business.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
