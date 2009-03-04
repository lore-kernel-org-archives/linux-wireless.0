Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:48886 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430AbZCDVlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 16:41:42 -0500
Message-ID: <49AEF58E.30302@lwfinger.net> (sfid-20090304_224144_527336_AD13DBC5)
Date: Wed, 04 Mar 2009 15:41:34 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Markus Feldmann <feldmann_markus@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: BCM4303 on HP zv5265ea
References: <gohr71$48f$1@ger.gmane.org> <49AC742D.9030309@lwfinger.net> <gom4ke$vle$1@ger.gmane.org> <49AE9BDD.7070603@lwfinger.net> <gomq5f$n64$1@ger.gmane.org>
In-Reply-To: <gomq5f$n64$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Markus Feldmann wrote:
> Larry Finger schrieb:
>> I looked at that mail again. Have you figured out how to get your
>> radio switch on?
> I have takled to Matthew Garret. And he told me to check whether i have
> an empty directory </sys/bus/pci/slots/> or not.
> Generally it should be not empty if the <acpiphp> modul works fine.
> 
> But thats all i know.

My system has an empty /sys/bus/pci/slots.

> Further on here is what Matthgew Garret said:
> "Some of these systems seem to use PCI express hotplug to handle the
> rfkill. Can you try with the latest git tree, and make sure that you
> have the acpiphp driver built in?"
> AND
> "Go to bus options/Support for PCI Hotplug/ACPI PCI Hotplug driver and
> enable it. You'll probably want it built-in to the kernel."

Did you do that?

> I have some printk statements activated.
> But i don't get more Debug messages than these in my
> old threads, or do you know some special debug kernel
> Options for wireless or general debug options ?
> 
> CONFIG_MAC80211_DEBUGFS
> CONFIG_MAC80211_VERBOSE_DEBUG
> CONFIG_MAC80211_VERBOSE_PS_DEBUG

I meant new printk statements that are used to see if hitting your switch causes
any action with RFKILL. I don't know where to put them, nor do I want to take
much time. I have an old BCM4306 and a BCM4301 - both work with b43legacy.

Larry

