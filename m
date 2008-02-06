Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24213 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342AbYBFHKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 02:10:49 -0500
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] at76_usb: Add ID for Uniden PCW100
References: <20080204050518.2696.50289.stgit@dv.roinet.com>
	<20080206022737.GL4252@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 06 Feb 2008 09:08:35 +0200
In-Reply-To: <20080206022737.GL4252@tuxdriver.com> (ext John W. Linville's message of "Tue\, 5 Feb 2008 21\:27\:37 -0500")
Message-ID: <87hcgmk1e4.fsf@nokia.com> (sfid-20080206_071104_426193_D22574D3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville <linville@tuxdriver.com> writes:

> Any word on when the mac80211 port of at76 will resurface?  

It's working now, somehow. I have some old patches against at76_usb
tree here:

http://www.valot.fi/kalle/at76/mac80211-port/20071227/

Also I have ported the patches against your tree and the new "band"
API. But they are not public yet, I need to test those first and after
that I will send the patches here for comments. Hopefully I can do
that this week.

> I'd love to get it into my tree for 2.6.26.

That would be great. I'll try to finish the port soon, so that we will
have enough time to get the driver into 2.6.26.

-- 
Kalle Valo
