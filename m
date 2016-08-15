Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53157 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbcHOGHX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2016 02:07:23 -0400
Message-ID: <1471241226.16783.5.camel@sipsolutions.net> (sfid-20160815_080743_754839_1FE7737E)
Subject: Re: [PATCH] Staging: rtl8723au: os_intfs: fixed case statement is
 variable issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>, sunbing <sunbing@redflag-linux.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sunbing.linux@gmail.com
Date: Mon, 15 Aug 2016 08:07:06 +0200
In-Reply-To: <1471177398.5201.9.camel@perches.com>
References: <1470924695-14931-1-git-send-email-sunbing@redflag-linux.com>
	 <wrfja8gje395.fsf@redhat.com>
	 <7FC388BC-FD87-44C6-87D3-AC041F1393DB@redflag-linux.com>
	 <wrfj7fbmawl1.fsf@redhat.com>
	 <E0CA1BD5-A2ED-4FDC-8E58-8024E2F3C24C@redflag-linux.com>
	 <1471176423.5201.7.camel@perches.com>
	 <1471176951.5903.6.camel@sipsolutions.net>
	 <1471177398.5201.9.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-08-14 at 05:23 -0700, Joe Perches wrote:
> 
> Maybe this test should be sparse version checked after
> sparse is updated.

*If* sparse ever gets updated :) I don't think it's been updated much
lately.
That said, I'm not even sure how, and what version, etc. so obviously
that'd have to be done after the fact. But since nobody will ever
compile the kernel with sparse's code generator, it also doesn't matter
anyway.

johannes
