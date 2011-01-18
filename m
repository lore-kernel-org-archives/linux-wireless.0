Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab1ARQXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 11:23:08 -0500
Subject: Re: WWAN driver for Huawei MU509 chip?
From: Dan Williams <dcbw@redhat.com>
To: "Brzezowski, Karen" <Karen.Brzezowski@pdt.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 18 Jan 2011 10:23:54 -0600
In-Reply-To: <0826983CC0CB074798C42E77D8ACD07F06921D@pdtms1.pdt.com>
References: <0826983CC0CB074798C42E77D8ACD07F06921D@pdtms1.pdt.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1295367834.1855.20.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 16:52 +0000, Brzezowski, Karen wrote:
> Is this the right mailing list for asking for information
> on drivers for the Huawei MU509 WCDMA chip?

No, it's not the right list.  But the MU509 appears to provide a USB
interface, and assuming it's the standard type of "vendor-specific USB
serial interface" then what you want to do is try adding the USB IDs of
the MU509 to the 'option' driver in the linux kernel, and then seeing if
you can talk to the device over ttyUSBx using minicom or screen.  Most
WWAN devices that provide USB interfaces expose at least one
AT-compatible serial port, and at the moment most Huawei UMTS/CDMA2000
devices are supported by the 'option' driver.

The specific list you want is linux-usb.

Dan


