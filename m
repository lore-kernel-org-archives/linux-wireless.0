Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030265AbaDJP0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 11:26:53 -0400
Date: Thu, 10 Apr 2014 08:29:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrea Merello <andrea.merello@gmail.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	driverdev-devel@linuxdriverproject.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: staging/rtl8187se should be removed
Message-ID: <20140410152936.GA10663@kroah.com> (sfid-20140410_172658_414638_F59DE7BE)
References: <53450089.9050008@gmail.com>
 <20140409170815.GA17551@kroah.com>
 <CAN8YU5M3h_og084bcdgqOGLoQqtrcxbxpPpAR6DBmYGz6pBG-w@mail.gmail.com>
 <20140410152136.GI26890@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140410152136.GI26890@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 10, 2014 at 06:21:36PM +0300, Dan Carpenter wrote:
> The thing about keeping e100 in parallel with the other driver is that
> some devices didn't work on the other driver and also it wasn't staging
> code.
> 
> I don't have strong opinions either way, but if we decide to keep the
> old driver around for another kernel release "just in case" then we
> should make it print a warning on load or something to say that it's
> soon going to be removed.

No, I'll just remove it entirely, no need for it to be around at all
anymore.

thanks,

greg k-h
