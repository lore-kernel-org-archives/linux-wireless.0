Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58967 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2DOJTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 05:19:38 -0400
Received: by wejx9 with SMTP id x9so2755319wej.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Apr 2012 02:19:36 -0700 (PDT)
Message-ID: <4F8A92A5.8090707@gmail.com> (sfid-20120415_112017_062083_C0856454)
Date: Sun, 15 Apr 2012 11:19:33 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, linville@tuxdriver.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com
Subject: Re: [rt2x00-users] [PATCH] wireless: rt2x00: rt2800usb add more devices
 ids
References: <1334448592-16391-1-git-send-email-xose.vazquez@gmail.com> <4F8A6CB6.4080006@01019freenet.de>
In-Reply-To: <4F8A6CB6.4080006@01019freenet.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/15/2012 08:37 AM, Andreas Hartmann wrote:

> Did you test them? What did you test exactly? What exactly works, what
> does not?

NO. NOTHING . I DON'T KNOW. But...

> It doesn't mean anything, if they work with the legacy driver.

..., the chips in these devices are *identified* . They perform so well
or so badly like those that are already in the driver(rt2800usb).

> Linksys WUSB600Nv2 e.g. works fine with the legacy driver, but only
> limited (if at all) with rt2800usb yet.

<http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/net/wireless/rt2x00/Kconfig;h=299c3879582da14e12ca00d7f11184da8c61bed7;hb=HEAD#l83>

config RT2800USB_RT35XX
	bool "rt2800usb - Include support for rt35xx devices ( *EXPERIMENTAL* )"
	depends on *EXPERIMENTAL*
