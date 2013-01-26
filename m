Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44566 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab3AZWM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 17:12:59 -0500
Message-ID: <51045387.2040607@gmail.com> (sfid-20130126_231313_358572_EA5CAA2E)
Date: Sat, 26 Jan 2013 23:07:03 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-usb@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	tom.rosary@googlemail.com
Subject: Re: bugreport upstream: 0bda:819a RTL8188CUS WLAN doesn't work out
 of the box
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Rosenkranz wrote:

> 0bda:819a RTL8188CUS WLAN doesn't work out of the box in downstream
> and upstreamkernel
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1102179

This should go to <linux-wireless@vger.kernel.org>

Try:
# modprobe rtl8192cu
# echo "0bda 819a" > /sys/bus/usb/drivers/rtl8192cu/new_id
# dmesg (see output)
