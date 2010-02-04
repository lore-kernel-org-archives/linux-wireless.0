Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cliff.cs.toronto.edu ([128.100.3.120]:55784 "EHLO
	cliff.cs.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758382Ab0BDW0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 17:26:21 -0500
To: Dan Williams <dcbw@redhat.com>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
Subject: Re: [PATCH] airo: fix setting zero length WEP key 
In-reply-to: dcbw's message of Thu, 04 Feb 2010 14:18:20 -0800.
             <1265321900.4290.20.camel@localhost.localdomain>
Date: Thu, 04 Feb 2010 17:26:18 -0500
From: Chris Siebenmann <cks@cs.toronto.edu>
Message-Id: <20100204222618.DE5D52B0054@apps0.cs.toronto.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

| When are you attempting to scan?  Is anything like wpa_supplicant or
| NetworkManager running in the background when you do this?

 My primary results are from Fedora 11's GNOME GUI (boot machine, log
in, attempt to connect to one of our wireless networks in various
places); I believe that this uses NetworkManager. I tried with iwlist
now and got the same results, but it looks like wpa_supplicant and
NetworkManager were both running at the time based on pstree output.

	- cks
