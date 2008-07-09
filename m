Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:29257 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbYGICaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 22:30:04 -0400
Subject: Re: Linux capable PDA with WLAN NIC that supports access point
	mode?
From: Pavel Roskin <proski@gnu.org>
To: pommnitz@yahoo.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <573701.63380.qm@web51408.mail.re2.yahoo.com>
References: <573701.63380.qm@web51408.mail.re2.yahoo.com>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 22:30:01 -0400
Message-Id: <1215570602.4232.6.camel@dv> (sfid-20080709_043009_152921_80F09BD2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-08 at 12:28 -0700, Joerg Pommnitz wrote:

> This is what I suspected, but according to 
> http://hostap.epitest.fi/hostapd/ only the following drivers
> are supported:

I don't think the hostapd page would actively advertize support for
proprietary driver available only for one embedded platform.

Anyway, from kamikaze 7.09 sources, docs/wireless.tex:

"Each wireless driver has its own configuration script
in /lib/wifi/driver_name.sh which handles driver specific options and
configurations. This script is also calling driver specific binaries
like wlc for Broadcom, or hostapd and wpa_supplicant for atheros.  The
reason for using such architecture, is that it abstracts the driver
configuration"

That means that hostapd is not used with the proprietary Broadcom
driver.

-- 
Regards,
Pavel Roskin
