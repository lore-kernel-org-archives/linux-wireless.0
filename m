Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2718 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab1KUJfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 04:35:19 -0500
Message-ID: <4ECA1B4B.5030607@broadcom.com> (sfid-20111121_103524_123365_6CA46280)
Date: Mon, 21 Nov 2011 10:35:07 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "michael caron couturier" <spikemcc@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: Driver support ...
References: <CAJKfDDEJacEhEOZYsYAkPYtgGsuu4+c6VPM=4CXRB5O=-v+xhw@mail.gmail.com>
In-Reply-To: <CAJKfDDEJacEhEOZYsYAkPYtgGsuu4+c6VPM=4CXRB5O=-v+xhw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2011 03:17 AM, michael caron couturier wrote:
> Hello,
> 
> I got to find a decent drivers for my needs on linux, I use Archlinux, here's my lscpi output :
> 
> 02:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller (rev 01)
> 
> I connect to a wifi adhoc from my 2nd laptop, it would be helpful to be able to make an adhoc connection also, I would need monitor mode for security test if possible, that would remove me the need of my bulky yagi usb antenna ...
> 
> Drivers or tools relatives to broadcom : b43, b43-fwcutter, b43-firmware-installer, wl, sta, brcm80211 ...
> 
> Mike

If adhoc is than you can either use proprietary wl driver [1] or b43
driver [2]. Both may be available in ArchLinux.

Gr. AvS

[1] http://www.broadcom.com/support/802.11/linux_sta.php
[2] http://wireless.kernel.org/en/users/Drivers/b43

