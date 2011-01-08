Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47033 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab1AHUdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 15:33:36 -0500
Received: by fxm20 with SMTP id 20so17850304fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Jan 2011 12:33:35 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Jason Andryuk <jandryuk@gmail.com>
Subject: Re: 5GHz 802.11n USB Adapter
Date: Sat, 8 Jan 2011 21:32:22 +0100
Cc: linux-wireless@vger.kernel.org
References: <AANLkTimj11OJRbjO2GBn=C36D7UDUURvguERS5XYoJ7W@mail.gmail.com>
In-Reply-To: <AANLkTimj11OJRbjO2GBn=C36D7UDUURvguERS5XYoJ7W@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101082132.22947.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 8. Januar 2011 schrieb Jason Andryuk:
> Are there any limitations for rt2800usb devices?  The wiki is short on
> information as is rt2x00.serialmonkey.com.  Does rt2800usb support AP
> mode like rt2800pci?

rt2800usb does not support bc- and mc- buffering (rt2800pci does). Hence,
powersaving stations might experience problems when using rt2800usb in AP
mode.

Helmut
