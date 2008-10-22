Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:46291 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYJVCES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 22:04:18 -0400
Received: by gxk9 with SMTP id 9so6669339gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 19:04:17 -0700 (PDT)
Message-ID: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com> (sfid-20081022_040424_748738_2DAD08F8)
Date: Tue, 21 Oct 2008 19:04:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Release of Atheros 802.11n USB Linux driver
Cc: "Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We would like to see our Atheros 802.11n USB Linux driver upstream
however we need help with this so we are releasing our Atheros 11n USB
Otus Linux driver under the ISC to the community. The goal is to work
with the community to help move this forward upstream. We are hoping
for community help and leadership on this (*cough*).

In the meantime users should be able to use this driver and patches
are welcomed to add newer wireless extension support so users on newer
kernels can get their devices working. The focus should be upstream
though :)

Anyway, some more details.

Supported hardware:

Atheros 802.11n hardware: UB81, UB82, UB83

Requirements:

Kernel 2.4 - 2.6.24

Get the driver:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/otus.git

Features supported:

  * IEEE standard compliance
  * IEEE 802.11a/b/g
  * IEEE 802.11h, 802.11d
  * IEEE 80211i
  * IEEE Draft 2.0 802.11n
  * Ad Hoc
        join (2.4GHz, 5GHz if SKU allows), create (2.4GHz , 5GHz if SKU allows)
        Adhoc security:  WEP
  * Security
    Authentication: WPA/WPA2 (Personal / Enterprise),
        802.1x Encryption: none, AES, TKIP, WEP40, WEP104

wpa_supplicant otus driver:

This driver requires its own supplicant driver for wpa_supplicant
0.4.8. For your convenience you can find the tarball here:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/otus/wpa_supplicant-0.4.8_otus.tar.bz2
