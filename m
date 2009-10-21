Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49480 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbZJUP3O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 11:29:14 -0400
Subject: Re: Broadcom 4318 not working with bleeding edge kernels
From: Pavel Roskin <proski@gnu.org>
To: Celejar <celejar@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20091020214702.a76fa4aa.celejar@gmail.com>
References: <20091020214702.a76fa4aa.celejar@gmail.com>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 11:29:17 -0400
Message-Id: <1256138957.26054.4.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-10-20 at 21:47 -0400, Celejar wrote:

> Oct 17 19:44:19 localhost wpa_supplicant[3477]: Trying to associate with 00:14:d1:3e:ff:30 (SSID='cranford' freq=2437 MHz)
> Oct 17 19:44:19 localhost wpa_supplicant[3477]: Association request to the driver failed

Since the message is from wpa_supplicant, it must be something between
wpa_supplicant and mac80211.  I don't think any code in b43 is involved.

Perhaps you should include some information about wpa_supplicant, i.e.
its version and the command line.  Please try the latest wpa_supplicant.
Please try both wext and nl80211 drivers.  That would help understand
the extent of the problem.

-- 
Regards,
Pavel Roskin
