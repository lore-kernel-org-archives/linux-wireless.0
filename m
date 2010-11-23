Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50036 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0KWMZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 07:25:37 -0500
Date: Tue, 23 Nov 2010 15:25:01 +0300
From: Dan Carpenter <error27@gmail.com>
To: Frantisek Hanzlik <franta@hanzlici.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andrea Merello <andreamrl@tiscali.it>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8180 freeze some i386 systems
Message-ID: <20101123122500.GD8882@bicker>
References: <4CEBA51C.5010604@hanzlici.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CEBA51C.5010604@hanzlici.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I added linux-wireless to the CC list.

If you're on the terminal is anything printed to the screen when the
system hangs?  echo 7 7 7 7 > /proc/sys/kernel/printk first to get more
messages.

If you create a bugzilla entry then you can take a digital photo of
the messages and attach it to your bug report.  (Although bugzilla is
crapping out today so you probably can't do that actually).

regards,
dan carpenter

On Tue, Nov 23, 2010 at 12:27:24PM +0100, Frantisek Hanzlik wrote:
> On two PCs with Fedora 14/i386 these systems freezes just after command
> "ip link set wlan0 up" was entered.
> "freezes" meant system is totally unuseable, ping to LAN interface
> hasn't reply, kbd/mouse not work, only way is HW reset/power off.
> 
> This hang occurs always independently on system runlevel: when switch to
> runlevel 1, when only kernel threads + udev + root bash are active,
> system still hangs.
> Systems hangs on all tested kernels 2.6.34, 2.6.35.9 and 2.6.36.
> Systems hangs with implicit cmdline and too when using "nomodeset",
> "acpi=noirq", "acpi=off", "pci=biosirq", "pci=routeirq", "pci=noacpi"
> parameters.
> 
> I have two Zyxel "G-302 v3" wifi adapters reported as RTL 8185 rev 20
> (10ec:8185), which on other two PCs with F1{3,4}/i386 and same config
> works well.
> 
> Can someone help with? Is some general method for solving this issue?
> 
> Thank in advance, Franta Hanzlik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
