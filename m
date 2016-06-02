Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56010 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161117AbcFBPgr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 11:36:47 -0400
Message-ID: <1464881803.2169.11.camel@sipsolutions.net> (sfid-20160602_173651_134254_EA3B1EC2)
Subject: Re: [PATCH] Support for 32 bit iwpriv on 64 bits kernels
From: Johannes Berg <johannes@sipsolutions.net>
To: Dibyajyoti Ghosh <dibyajyotig@gmail.com>
Cc: WiFi Mailing List <linux-wireless@vger.kernel.org>,
	Ujjal Roy <royujjal@gmail.com>,
	Prasun Maiti <prasunmaiti87@gmail.com>
Date: Thu, 02 Jun 2016 17:36:43 +0200
In-Reply-To: <1464880903-13116-1-git-send-email-dibyajyotig@gmail.com> (sfid-20160602_171743_730703_8CFD546B)
References: <1464880903-13116-1-git-send-email-dibyajyotig@gmail.com>
	 (sfid-20160602_171743_730703_8CFD546B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-06-02 at 20:51 +0530, Dibyajyoti Ghosh wrote:
> This patch adds pointer conversion from 32 bit to 64 bit and vice
> versa,
> if the ioctl is issued from 32 bit iwpriv to 64 bit Kernel.
> 
Huh? the kernel should handle that, no? And didn't you just submit a
patch for it, so you break it again with this change?

johannes
