Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:39467 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754130AbeAQUrv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 15:47:51 -0500
MIME-Version: 1.0
From: Cristian <caravena@gmail.com>
Date: Wed, 17 Jan 2018 17:47:50 -0300
Message-ID: <CABwnbU=Z7zJd8zL-0qkEnNHgQyvLCQ+85d1oMh+FKM83rzmoSA@mail.gmail.com> (sfid-20180117_214803_967945_43D74B0A)
Subject: Not work 802.11ac WLAN Adapter
To: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Open bug in launchpad.net
https://bugs.launchpad.net/bugs/1743872

dmesg_4.15.0-041500rc8-generic

dmesg:
[ 104.468231] usb 3-2: new high-speed USB device number 4 using xhci_hcd
[ 104.616570] usb 3-2: New USB device found, idVendor=0bda, idProduct=a811
[ 104.616578] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 104.616582] usb 3-2: Product: 802.11ac WLAN Adapter
[ 104.616585] usb 3-2: Manufacturer: Realtek
[ 104.616588] usb 3-2: SerialNumber: 00e04c000001

Regards,
-- 
Cristian
