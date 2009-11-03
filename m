Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.216.179]:53939 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZKCRtf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 12:49:35 -0500
Date: Tue, 3 Nov 2009 09:49:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Marcel Holtmann <marcel@holtmann.org>,
	David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
	7d930bc33653d5592dc386a76a38f39c2e962344
Message-ID: <20091103174934.GA16413@core.coreip.homeip.net>
References: <20091102.224957.32364226.davem@davemloft.net> <20091103065238.GE3212@core.coreip.homeip.net> <1257232587.3420.55.camel@localhost.localdomain> <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain> <1257262588.3420.79.camel@localhost.localdomain> <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain> <1257264485.3420.87.camel@localhost.localdomain> <20091103162955.GA4836@elte.hu> <43e72e890911030924n26550ee4j619a41ec016281ea@mail.gmail.com> <alpine.LFD.2.01.0911030930130.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LFD.2.01.0911030930130.31845@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 03, 2009 at 09:37:00AM -0800, Linus Torvalds wrote:
> 
> (And no, as far as I can tell, it needs no suspend/resume cycle at all. I 
> don't know the code very well, but as far as I can tell it just needs a 
> wireless deauthentication, which easily happens if you're running 
> something like NetworkManager and your wireless network may be noisy or 
> weak).
> 

I think I also hit it once by disabling the wireless through network
manager (wanted to refresh DHCP server list in resolv.conf)... But that
operation is not as common as suspend/resume for me.

-- 
Dmitry
