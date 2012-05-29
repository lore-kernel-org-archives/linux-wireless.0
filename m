Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10216 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2E2KSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 06:18:12 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20420.41522.130102.644989@gargle.gargle.HOWL> (sfid-20120529_121816_065200_0A8D86A6)
Date: Tue, 29 May 2012 15:47:22 +0530
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
	<ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: ath9k stops working (DMA trouble?) shortly after going online
In-Reply-To: <201205281528.15852.tvrtko.ursulin@onelan.co.uk>
References: <201205281316.15008.tvrtko.ursulin@onelan.co.uk>
	<CAD2nsn26Ey+ws4D82LSSsCT2mB5NhQ-35Dts9xx=6=JyDzYPPQ@mail.gmail.com>
	<201205281528.15852.tvrtko.ursulin@onelan.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tvrtko Ursulin wrote:
> On Monday 28 May 2012 14:01:41 Mohammed Shafi wrote:
> > On Mon, May 28, 2012 at 5:46 PM, Tvrtko Ursulin
> > 
> > <tvrtko.ursulin@onelan.co.uk> wrote:
> > > Hi all,
> > > 
> > > This is on kernel 3.3.2, with the following hardware:
> > > 
> > > 03:00.0 Network controller: Atheros Communications Inc. AR928X Wireless
> > > Network Adapter (PCI-Express) (rev 01)
> > > 
> > > dmesg below. I wonder if this is a known issue and I should try
> > > X, Y or Z for a fix? Or any other info / debugging you would like
> > > me to do just ask.
> > 
> > can you  please try if this helps
> > http://www.spinics.net/lists/linux-wireless/msg90835.html
> 
> I have switched to today's git for testing where I could reproduce the 
> problem. Then on top of that I tried the suggested patch but unfortunately 
> breakage is still there and looks similar to me. New dmesg attached.

Can you load the driver with debug=0x8f49 and post the log here ?
Note that debugging has to be enabled [1]

[1] - http://linuxwireless.org/en/users/Drivers/ath9k/debug

Sujith
