Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:44701 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYJXB6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 21:58:00 -0400
Received: by wr-out-0506.google.com with SMTP id 69so24510wri.5
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 18:57:59 -0700 (PDT)
Message-ID: <43e72e890810231857m5262d975i7f67615362cde15b@mail.gmail.com> (sfid-20081024_035817_100497_0F4C2A9B)
Date: Thu, 23 Oct 2008 18:57:59 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Carlo Nyto" <carlonyto@gmail.com>
Subject: Re: Best USB wireless interface with Linux?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <9d95d80e0810231803p6e753150w36fcd6d657613a27@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <9d95d80e0810231803p6e753150w36fcd6d657613a27@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 23, 2008 at 6:03 PM, Carlo Nyto <carlonyto@gmail.com> wrote:
> I am looking to choose a USB wireless network interface that works
> well under Linux.

Atheros zd1211rw:
http://wireless.kernel.org/en/users/Drivers/zd1211rw

Atheros otus (802.11n, not upstream though):

http://wireless.kernel.org/en/users/Drivers/otus

* Intersil p54:

http://wireless.kernel.org/en/users/Drivers/p54

rndis_wlan:

http://wireless.kernel.org/en/users/Drivers/rndis_wlan

* Marvel usb -- no website

I'll be inclined to support zd1211rw due to the amount of time its
been in the kernel and the amount of wide testing it has received.
Atheros 11n otus is the only 11n usb driver I'm aware of for Linux.

  Luis
