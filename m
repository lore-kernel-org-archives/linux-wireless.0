Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muse.oxfordinspire.co.uk ([93.93.128.48]:60046 "EHLO
	muse.oxfordinspire.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab1ECNh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 09:37:26 -0400
Message-ID: <4DBFFE64.6000306@exotica.org.uk> (sfid-20110503_153744_642635_8F0F6A61)
Date: Tue, 03 May 2011 14:08:52 +0100
From: Jools Wills <buzz@exotica.org.uk>
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Roland Dreier <roland@kernel.org>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
References: <484421.61252.qm@web161619.mail.bf1.yahoo.com>
In-Reply-To: <484421.61252.qm@web161619.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in case it is useful:

I am currently using the vendor driver on a device I have (O2 Joggler).
The rt2800usb driver didn't work well and the staging rt2870sta driver
didn't seem to work with wireless N and users reported to me that it
drops the connection and is unreliable. The vendor driver does seem to
work best.

I made a debian package (using dkms) of the vendor driver on my joggler
ppa. tested working wiht 2.6.37/2.6.38

https://launchpad.net/~jools/+archive/joggler

note it doesn't automatically install the newer firmware so that will
need to be done manually.

Best Regards

Jools
