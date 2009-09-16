Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:8593 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbZIPVAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 17:00:14 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1312752fge.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 14:00:17 -0700 (PDT)
Subject: Re: [PATCH 2/2] b43: Add lpphy_clear_tx_power_offsets to improve
 TX Power handling
From: Thomas Ilnseher <illth@gmx.de>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <69e28c910909161344h511bcddeqcdc82b2e8a734dbb@mail.gmail.com>
References: <1253129879.2989.48.camel@note>
	 <69e28c910909161240p7739edebi653b5d402a792856@mail.gmail.com>
	 <1253132275.2989.75.camel@note>
	 <69e28c910909161344h511bcddeqcdc82b2e8a734dbb@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 23:00:17 +0200
Message-Id: <1253134817.3015.2.camel@note>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 
> Put a printk here to see if this branch is getting hit.
> 
> (BTW, are you loading b43 with the "hwpctl" modparam? That enables
> experimental HW TX power control support, which might explain what you
> were seeing.)
Hi Gabor,

I'm stupid.

I applied 3 Patches, the analog switch patch, and the other two patches.
The analog switch patch did it.



> >>
> >>
> >
> >
> 
> 
> 

