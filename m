Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:17123 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbYCLBqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 21:46:23 -0400
Received: by an-out-0708.google.com with SMTP id d31so644869and.103
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2008 18:46:22 -0700 (PDT)
Reply-To: <cs010101@gmail.com>
From: =?ks_c_5601-1987?B?sei/tciv?= <cs010101@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: Q) after loading rt2x00 driver, can't set 'ifconfig'
Date: Wed, 12 Mar 2008 10:46:14 +0900
Message-ID: <001d01c883e2$ddf6b680$3b0aa8c0@39fb6b6b6f434b3> (sfid-20080312_014626_399185_C6728475)
MIME-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I received Ralink module from IEI corp, today.
I did test.


iwconfig setting

--------------------------------------------------
[root@localhost compat-wireless-2.6-20080311]# iwconfig wlan3 essid kkk
mode ad-hoc channel 161 rate 18Mb
[root@localhost compat-wireless-2.6-20080311]# iwconfig=20
lo        no wireless extensions.

eth0      no wireless extensions.

virbr0    no wireless extensions.

wmaster0  no wireless extensions.

wlan3     IEEE 802.11a  ESSID:"kkk" =20
          Mode:Ad-Hoc  Frequency:5.805 GHz  Cell: Not-Associated  =20
          Tx-Power=3D17 dBm  =20
          Retry min limit:7   RTS thr:off   Fragment thr=3D2346 B  =20
          Encryption key:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

[root@localhost compat-wireless-2.6-20080311]# ifconfig wlan3
100.100.100.100
SIOCSIFFLAGS: not support command
--------------------------------------------------


when setting 'ifconfig wlan3 100.100.100.100', dmesg is like follwings:

--------------------------------------------------
phy0 -> rt61pci_init_bbp: Debug - Start initialization from EEPROM...
phy0 -> rt61pci_init_bbp: Debug - ...End initialization from EEPROM.
phy0 -> rt2x00mac_add_interface: Error - rt2x00 does not support Adhoc =
or
Master mode<3>phy0 -> rt61pci_mcu_request: Error - mcu request error.
Request 0x50 failed for token 0xff.
--------------------------------------------------


--
--
Have a Wonderful Day~~!!
=B1=E8=BF=B5=C8=AF (James-Youngwhan Kim)
yhkim@corebell.co.kr
cs010101@gmail.com
+82-42-863-0340
+82-10-6753-0987
HTVC 3106 KAIST, 373-1 Guseong-dong, Yuseong-gu,
Daejon,  Republic of Korea
305-701

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
