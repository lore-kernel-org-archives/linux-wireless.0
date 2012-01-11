Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33072 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab2AKXHz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 18:07:55 -0500
Received: by werm1 with SMTP id m1so937886wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 15:07:54 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Jan 2012 17:07:54 -0600
Message-ID: <CAJ8GFOgazS1MWk+vaNHd=SCtenO+6fYty-_JqZVGX5+xa04dDg@mail.gmail.com> (sfid-20120112_000758_732655_A25408AB)
Subject: carl9170: How to control transmit power?
From: Harshal Chhaya <harshal@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Does the carl9170 driver/firmware allow real-time updates to the tx
power parameter?

On my AR9170-based AP, I can't set the tx power using either 'iw' or 'iwconfig'.

'iw' fails with an error message:

root@OpenWrt:/etc/hostapd# iw wlan0 set txpower fixed 10
command failed: Operation not supported (-95)


'iwconfig' seems to update the information that's displayed but it
doesn't affect the actual tx power

root@OpenWrt:/# iwconfig wlan0
wlan0     IEEE 802.11bgn  Mode:Master  Frequency:2.412 GHz  Tx-Power=7 dBm
          RTS thr:off   Fragment thr:off
          Power Management:off

root@OpenWrt:/# iwconfig wlan0 txpower 11

root@OpenWrt:/# iwconfig wlan0
wlan0     IEEE 802.11bgn  Mode:Master  Frequency:2.412 GHz  Tx-Power=11 dBm
          RTS thr:off   Fragment thr:off
          Power Management:off


Is there another way to set the tx power? I want to reduce the range
of my AP and am trying to lower the tx power.

Thanks,
- Harshal
