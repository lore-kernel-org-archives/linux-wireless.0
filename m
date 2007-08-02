Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.237]:21766 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbXHBKYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 06:24:04 -0400
Received: by hu-out-0506.google.com with SMTP id 19so316471hue
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2007 03:24:03 -0700 (PDT)
Message-ID: <46B1B0AE.7050205@gmail.com>
Date: Thu, 02 Aug 2007 12:23:42 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: rt2500usb stopped working (vendor request error)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I was using rt2x00 with hostapd to create a AP and it worked fine in FC6 
with rt2x00-cvs-2007020803.
But after upgrading to F7 it stopped working. I am using kernel 
kernel-2.6.22.1-41.fc7 which have a recent wireless-dev copy of the 
driver but I just get this errors in dmesg:

[...]
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for 
offset 0x04d0 with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for 
offset 0x04d0 with error -71.
phy0 -> rt2500usb_bbp_read: Error - PHY_CSR8 register busy. Read failed.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for 
offset 0x04e6 with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for 
offset 0x04d0 with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for 
offset 0x04ce with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for 
offset 0x04d0 with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for 
offset 0x04ce with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for 
offset 0x04d0 with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for 
offset 0x04ce with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for 
offset 0x04d0 with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for 
offset 0x04ce with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for 
offset 0x04d0 with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for 
offset 0x04d0 with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for 
offset 0x04d0 with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for 
offset 0x04d0 with error -71.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for 
offset 0x04d0 with error -71.
phy0 -> rt2500usb_bbp_read: Error - PHY_CSR8 register busy. Read failed.
[...]

Any idea whats going on?
Can I provide more info to help finding a solution?
I already reported it here before:
http://rt2x00.serialmonkey.com/phpBB2/viewtopic.php?t=4042
but got no usefull replies so I decided to try here.

P.S: please cc me when replying.

