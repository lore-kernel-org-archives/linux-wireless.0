Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pv35p12im-ztdg05031101.me.com ([17.133.186.213]:46393 "EHLO
        pv35p12im-ztdg05031101.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754113AbdHWPAN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 11:00:13 -0400
Received: from process-dkim-sign-daemon.pv35p12im-ztdg05031101.me.com by
 pv35p12im-ztdg05031101.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0OV500M0078S3Q00@pv35p12im-ztdg05031101.me.com> for
 linux-wireless@vger.kernel.org; Wed, 23 Aug 2017 15:00:13 +0000 (GMT)
Received: from icloud.com ([127.0.0.1]) by pv35p12im-ztdg05031101.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) with ESMTPSA id <0OV500HNV8C8ZY40@pv35p12im-ztdg05031101.me.com> for
 linux-wireless@vger.kernel.org; Wed, 23 Aug 2017 15:00:11 +0000 (GMT)
From: =?utf-8?Q?H=C3=A5vard_Rabbe?= <hrabbe@me.com>
Content-type: text/plain; charset=utf-8
MIME-version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: How can I get WDS to work? I need some help
Message-id: <6B96DBC1-F290-4853-BC5F-F884727BF591@me.com> (sfid-20170823_170017_289214_D6D7BDC5)
Date: Wed, 23 Aug 2017 17:00:08 +0200
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Im trying to get wds working. I haven=E2=80=99t found much documentation =
on this topic. This is what i have found: =
https://wireless.wiki.kernel.org/en/users/documentation/iw#setting_up_a_wd=
s_peer

I have configured two machines with hostapd with the same config. Its =
also the same wifi card WLE200NX using the AR9280 chipset.

After APs is running I have used this commands on both AP=E2=80=99s with =
the other APs wifi mac address:

iw phy phy0 interface add wds0 type wds
iw dev wds0 set peer <MAC address>

then wds0 interface is showing up

------------------
wds0      IEEE 802.11abgn  Mode:Repeater  Access Point: Not-Associated  =20=

          Tx-Power=3D20 dBm  =20
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
---------------------


But it says Access Point: Not-Associated


I have no clue what to do next.

Is there anyone who know something about this?

Thank you for any help


Best Regards,

H=C3=A5vard Rabbe=
