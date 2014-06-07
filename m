Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:60584 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaFGSy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 14:54:56 -0400
Received: by mail-oa0-f52.google.com with SMTP id j17so661446oag.11
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jun 2014 11:54:56 -0700 (PDT)
Message-ID: <53935FFE.10708@lwfinger.net> (sfid-20140607_205514_825256_B4CA5872)
Date: Sat, 07 Jun 2014 13:54:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Powerful Notageek <powerfulnotageek@yahoo.in>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: MT7630e availability in kernel by default
References: <1402159087.63238.YahooMailNeo@web193001.mail.sg3.yahoo.com> <53935133.5020303@lwfinger.net> <1402163980.67578.YahooMailNeo@web193003.mail.sg3.yahoo.com> <539356EA.1070004@lwfinger.net> <1402165531.45127.YahooMailNeo@web193003.mail.sg3.yahoo.com>
In-Reply-To: <1402165531.45127.YahooMailNeo@web193003.mail.sg3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2014 01:25 PM, Powerful Notageek wrote:
> I tried them and here's the output: (verbose)
>
> [root@localhost ~]# modprobe -v rt2800pci
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/lib/crc-ccitt.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/net/wireless/cfg80211.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/net/mac80211/mac80211.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/misc/eeprom/eeprom_93cx6.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2x00mmio.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2x00pci.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2800lib.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2800mmio.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2800pci.ko
> [root@localhost ~]# echo "14c3 7630" > /sys/bus/pci/drivers/rt2800pci/new_id
> [root@localhost ~]# iwconfig
> p3p1      no wireless extensions.
>
> lo        no wireless extensions.

When you do the above, what ends up in the dmesg output? In particular, is the 
firmware available?

Larry


