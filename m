Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40146 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaDJPWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 11:22:05 -0400
Date: Thu, 10 Apr 2014 18:21:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	driverdev-devel@linuxdriverproject.org,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: staging/rtl8187se should be removed
Message-ID: <20140410152136.GI26890@mwanda> (sfid-20140410_172212_266057_C8E322BB)
References: <53450089.9050008@gmail.com>
 <20140409170815.GA17551@kroah.com>
 <CAN8YU5M3h_og084bcdgqOGLoQqtrcxbxpPpAR6DBmYGz6pBG-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN8YU5M3h_og084bcdgqOGLoQqtrcxbxpPpAR6DBmYGz6pBG-w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The thing about keeping e100 in parallel with the other driver is that
some devices didn't work on the other driver and also it wasn't staging
code.

I don't have strong opinions either way, but if we decide to keep the
old driver around for another kernel release "just in case" then we
should make it print a warning on load or something to say that it's
soon going to be removed.

regards,
dan carpenter

