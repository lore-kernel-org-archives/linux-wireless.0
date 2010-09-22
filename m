Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33271 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab0IVUjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 16:39:04 -0400
Received: by ywh1 with SMTP id 1so329679ywh.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 13:39:03 -0700 (PDT)
MIME-Version: 1.0
From: Alberto Donato <alberto.donato@gmail.com>
Date: Wed, 22 Sep 2010 22:38:38 +0200
Message-ID: <AANLkTik_68KKkQJ0N_BJFYRsv4L+iXa5V1+MQ=n-v=Y0@mail.gmail.com>
Subject: Old Otus driver with WEP
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
  I'm using the old otus driver on a mips platform which is currently
using a  2.6.18 kernel with a TP-Link TL-WN821N usb adapter.

While WPA/WPA2 works fine with the associated wpa_supplicant otus
driver, I'm unable to authenticate with WEP (boh 64 and 128 bit)
My wpa_supplicant configuration is:

network={
        ssid="mynetwork"
        scan_ssid=1
        key_mgmt=NONE
        auth_alg=SHARED
        group=WEP104 WEP40
        wep_key0=<my key>
        wep_tx_keyidx=0
}

The Otus driver mailing list isn't answering, so I'm trying here.
>From the driver page is not even clear if the driver supports WEP at
all (it is stated as feature only in ad-hoc mode).

Anyone had similar problems?

Thanks,
   Alberto
