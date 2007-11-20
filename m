Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:57093 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805AbXKTCdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 21:33:53 -0500
Message-ID: <4742478B.3090908@lwfinger.net> (sfid-20071120_023400_674209_3F64C5F1)
Date: Mon, 19 Nov 2007 20:33:47 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>, mb@bu3sch.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] remove bcm43xx
References: <20071119202121.6ad3fa70@morte> <200711192300.12183.rjw@sisk.pl> <20071119231935.535674ba@morte> <200711192357.44407.rjw@sisk.pl>
In-Reply-To: <200711192357.44407.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafael J. Wysocki wrote:
> 
> Many people use the old driver and you are forcing them to switch in a rather
> unfriendly fashion.
> 
> Moreover, the switch generally involves a configuration change (on my system
> eth1 became wlan0) and is not _that_ seamless.

That change is in udev and has nothing to do with the bcm43xx - b43 change. The renaming will happen
even though one stays with bcm43xx.

Larry
