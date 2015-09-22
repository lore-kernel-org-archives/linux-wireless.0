Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52305 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbbIVOFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 10:05:52 -0400
Message-ID: <1442930747.2018.12.camel@sipsolutions.net> (sfid-20150922_160614_126271_72978CD7)
Subject: Re: [PATCH v2] net/wireless: enable wiphy device to suspend/resume
 asynchronously
From: Johannes Berg <johannes@sipsolutions.net>
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>,
	David Miller <davem@davemloft.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Sep 2015 16:05:47 +0200
In-Reply-To: <55FCCB0E.3000807@linux.intel.com>
References: <55FCCB0E.3000807@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-09-19 at 10:40 +0800, Fu, Zhonghui wrote:
> Now, PM core supports asynchronous suspend/resume mode for devices
> during system suspend/resume, and the power state transition of one
> device may be completed in separate kernel thread. PM core ensures
> all power state transition timing dependency between devices. This
> patch enables wiphy device to suspend/resume asynchronously. This can
> take advantage of multicore and improve system suspend/resume speed.
> 

Applied.

johannes
