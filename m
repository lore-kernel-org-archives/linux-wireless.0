Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:29541 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab0KWTOr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:14:47 -0500
Subject: Re: No scan results from wl1271-sdio
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Josh Watts <JWatts@d3engineering.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"shahar_levi@ti.com" <shahar_levi@ti.com>
In-Reply-To: <AB927C5B3615784183753F31BCC83EA38C58FE30@AD.d3.local>
References: <AB927C5B3615784183753F31BCC83EA38C58FE29@AD.d3.local>
	 <1290534680.5617.11.camel@powerslave>
	 <AB927C5B3615784183753F31BCC83EA38C58FE30@AD.d3.local>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 21:14:39 +0200
Message-ID: <1290539679.5617.21.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-23 at 13:51 -0500, ext Josh Watts wrote:
> See attached (wlan0.log.20101123_1317 201.4KiB) for the debug log
> (copy of /var/log/messages) sans DEBUG_SDIO. 

According to the logs, everything seems to go well, including the probe
requests seem to be configure correctly before the scan.  But I don't
see any RX interrupts...

Do you have a sniffer or a device that can be put into monitor mode to
use with wireshark? If you do, an airlog of this scenario will probably
give us more clues...


-- 
Cheers,
Luca.

