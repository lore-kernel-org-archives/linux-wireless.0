Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933353AbaDIRFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 13:05:44 -0400
Date: Wed, 9 Apr 2014 10:08:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: driverdev-devel@linuxdriverproject.org, andrea.merello@gmail.com,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: staging/rtl8187se should be removed
Message-ID: <20140409170815.GA17551@kroah.com> (sfid-20140409_190554_585082_F44C2328)
References: <53450089.9050008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53450089.9050008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 09, 2014 at 10:10:49AM +0200, Xose Vazquez Perez wrote:
> hi,
> 
> Support for RTL8187SE devices(0x8199) was added to
> rtl8180 recently. See 1eba648f998ef9c31b8cf062754a4a7b4ab9001f

Very nice, so, any objection to me deleting the staging driver now?

thanks,

greg k-h
