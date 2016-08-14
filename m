Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46983 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbcHNMQL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2016 08:16:11 -0400
Message-ID: <1471176951.5903.6.camel@sipsolutions.net> (sfid-20160814_141633_000031_E5E87217)
Subject: Re: [PATCH] Staging: rtl8723au: os_intfs: fixed case statement is
 variable issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>, sunbing <sunbing@redflag-linux.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sunbing.linux@gmail.com
Date: Sun, 14 Aug 2016 14:15:51 +0200
In-Reply-To: <1471176423.5201.7.camel@perches.com>
References: <1470924695-14931-1-git-send-email-sunbing@redflag-linux.com>
	 <wrfja8gje395.fsf@redhat.com>
	 <7FC388BC-FD87-44C6-87D3-AC041F1393DB@redflag-linux.com>
	 <wrfj7fbmawl1.fsf@redhat.com>
	 <E0CA1BD5-A2ED-4FDC-8E58-8024E2F3C24C@redflag-linux.com>
	 <1471176423.5201.7.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> It's a sparse defect.
> 
> Try again after patching sparse with Jes' patch:
> http://marc.info/?l=linux-sparse&m=147091200720267&w=3

Mine, not Jes's ;-)

But there's another patch going into the kernel to fix it:

https://www.ozlabs.org/~akpm/mmotm/broken-out/byteswap-dont-use-__builtin_bswap-with-sparse.patch

johannes
