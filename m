Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:6816 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYALMF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2008 07:05:26 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1488262fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jan 2008 04:05:23 -0800 (PST)
To: Thomas =?iso-8859-15?q?B=E4chler?= <thomas@archlinux.org>
Subject: Re: [rt2x00] rt2500pci massive speed problems
Date: Sat, 12 Jan 2008 13:05:16 +0100
Cc: linux-wireless@vger.kernel.org
References: <fma7v9$cn7$1@ger.gmane.org>
In-Reply-To: <fma7v9$cn7$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801121305.16205.IvDoorn@gmail.com> (sfid-20080112_120530_958361_DECF85FB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I have a MSI PC54G2 Wireless NIC:
> 00:0b.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
> 00:0b.0 0280: 1814:0201 (rev 01)
> 
> I have tested the speed with different rt2500pci versions and with the
> rt2500 legacy driver, using a D-Link DI-524 wireless router in mixed
> WPA/WPA2 TKIP/CCMP mode:
> 
> Linux 2.6.23.13, rt2x00 from CVS, the last version I got to compile with
> 2.6.23 (a copy of this source is here:
> ftp://ftp.archlinux.org/other/rt2x00-cvs/rt2x00-cvs-20070914.tar.bz2):
> The speed is about 100KB/s.
> 
> Linux 2.6.24-rc7 (pulled from linux-2.6 git today):
> The speed is about 20KB/s, which is obviously _much_ slower than the
> older version above.
> 
> Linux 2.6.23.13, latest rt2500 legacy release.
> Speed is over 1MB/s when downloading from the Internet, 900KB/s when
> downloading from another client on the same WLAN, which is a sane result
> IMO.
> 
> As you can see, the rt2500pci included in 2.6.24 is unusable when it
> comes to speed, older versions were partially usable. However, if you
> need good speed, the only way is to fall back to the legacy driver, with
> the obvious problems (lack of wpa_supplicant support, thus only limited
> WPA support).

Set the rate to 54Mbs instead of auto, other people reported that that should help.

Ivo

