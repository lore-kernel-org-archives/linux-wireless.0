Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:39574 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbZCDVAr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 16:00:47 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LeyCm-00011Z-8d
	for linux-wireless@vger.kernel.org; Wed, 04 Mar 2009 21:00:40 +0000
Received: from dslb-092-076-245-153.pools.arcor-ip.net ([92.76.245.153])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 21:00:40 +0000
Received: from feldmann_markus by dslb-092-076-245-153.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 21:00:40 +0000
To: linux-wireless@vger.kernel.org
From: Markus Feldmann <feldmann_markus@gmx.de>
Subject: Re: BCM4303 on HP zv5265ea
Date: Wed, 04 Mar 2009 22:00:30 +0100
Message-ID: <gomq5f$n64$1@ger.gmane.org> (sfid-20090304_220050_914104_24256921)
References: <gohr71$48f$1@ger.gmane.org> <49AC742D.9030309@lwfinger.net> <gom4ke$vle$1@ger.gmane.org> <49AE9BDD.7070603@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <49AE9BDD.7070603@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:
> I looked at that mail again. Have you figured out how to get your radio switch on?
I have takled to Matthew Garret. And he told me to check whether i have
an empty directory </sys/bus/pci/slots/> or not.
Generally it should be not empty if the <acpiphp> modul works fine.

But thats all i know.

Further on here is what Matthgew Garret said:
"Some of these systems seem to use PCI express hotplug to handle the
rfkill. Can you try with the latest git tree, and make sure that you
have the acpiphp driver built in?"
AND
"Go to bus options/Support for PCI Hotplug/ACPI PCI Hotplug driver and
enable it. You'll probably want it built-in to the kernel."

> There are no developers that are working on b43legacy. Whenever a bug is found
> in b43, I will propagate it to b43legacy, but that is the extent of development.
> 
> Unfortunately, none of us have a card with an RFKILL switch that uses b43legacy.
> Without hardware in hand, debugging is too difficult. You will need to put
> printk statements in your copy of the driver to find out where it fails.
I have some printk statements activated.
But i don't get more Debug messages than these in my
old threads, or do you know some special debug kernel
Options for wireless or general debug options ?

CONFIG_MAC80211_DEBUGFS
CONFIG_MAC80211_VERBOSE_DEBUG
CONFIG_MAC80211_VERBOSE_PS_DEBUG

Maybe some kernel_hacking Options ?


