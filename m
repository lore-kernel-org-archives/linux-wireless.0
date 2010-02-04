Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cliff.cs.toronto.edu ([128.100.3.120]:57148 "EHLO
	cliff.cs.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab0BDXD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 18:03:56 -0500
To: Dan Williams <dcbw@redhat.com>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
Subject: Re: [PATCH] airo: fix setting zero length WEP key 
In-reply-to: dcbw's message of Thu, 04 Feb 2010 15:00:13 -0800.
             <1265324413.4290.35.camel@localhost.localdomain>
Date: Thu, 04 Feb 2010 18:03:55 -0500
From: Chris Siebenmann <cks@cs.toronto.edu>
Message-Id: <20100204230355.281A32B0054@apps0.cs.toronto.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

| >  I'm not sure what the machine's exact configuration is because
| > I inherited it (the usual long cycle of passing older and older
| > hardware around at work), but I believe it must; I certainly don't
| > have anything plugged into any external slots or sockets.
|
| And just to confirm, what are the exact symptoms that you have with
| "broken" kernels?  Just that connections can't be made, the card can't
| find access points, etc? or?

 In the GUI, no wireless networks show up/are listed in the usual
dropdown menu; this means that I can't go as far as even trying to
connect to anything.  From the command line, 'iwlist wifi0 scanning'
lists nothing.

	- cks
