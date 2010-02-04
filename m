Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab0BDXBz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 18:01:55 -0500
Subject: Re: [PATCH] airo: fix setting zero length WEP key
From: Dan Williams <dcbw@redhat.com>
To: Chris Siebenmann <cks@cs.toronto.edu>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
In-Reply-To: <20100204224254.058832B0054@apps0.cs.toronto.edu>
References: <20100204224254.058832B0054@apps0.cs.toronto.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 15:00:13 -0800
Message-ID: <1265324413.4290.35.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-02-04 at 17:42 -0500, Chris Siebenmann wrote:
> | > | When are you attempting to scan?  Is anything like wpa_supplicant
> | > | or NetworkManager running in the background when you do this?
> | >
> | >  My primary results are from Fedora 11's GNOME GUI (boot machine,
> | > log in, attempt to connect to one of our wireless networks in
> | > various places); I believe that this uses NetworkManager. I tried
> | > with iwlist now and got the same results, but it looks like
> | > wpa_supplicant and NetworkManager were both running at the time
> | > based on pstree output.
> |
> | Ok, that should be fine since wpa_supplicant is the only thing hitting
> | the airo up for scans and whatnot.  I'm grabbing a kernel now to do
> | some testing with my 350 (PCMCIA).  I assume you have an internal
> | minicard?
> 
>  I'm not sure what the machine's exact configuration is because I
> inherited it (the usual long cycle of passing older and older hardware
> around at work), but I believe it must; I certainly don't have anything
> plugged into any external slots or sockets.

And just to confirm, what are the exact symptoms that you have with
"broken" kernels?  Just that connections can't be made, the card can't
find access points, etc?  or?

Dan


