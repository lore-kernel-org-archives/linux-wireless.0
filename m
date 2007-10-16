Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.uludag.org.tr ([193.140.100.220]:48397 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757818AbXJPKRl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 06:17:41 -0400
Received: from ninjamobile.local (unknown [85.102.69.93])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by uludag.org.tr (Postfix) with ESMTP id 2ECB518A064
	for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 13:17:27 +0300 (EEST)
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
To: linux-wireless@vger.kernel.org
Subject: Problem with in-kernel iwl3945 driver
Date: Tue, 16 Oct 2007 13:17:45 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710161317.45460.ismail@pardus.org.tr> (sfid-20071016_111745_512843_6BE33D21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I was using iwlwifi.git from intellinuxwireless.org with 2.6.23 kernel and it 
worked like a charm. Now I updated to latest Linus' GIT tree and basically 
wireless sufffers.

Here are some problems I encountered:

- Can't associate unless I do a iwlist wlan0 scan, until then it can't find 
the AP.

- Even I associate Bitrate is 5,5 Mb/s but AP have up to 48 Mb/s and I am 
basically 1 meter away from AP. iwconfig output is like this:

wlan0     IEEE 802.11b  ESSID:"XXYYZZ"
          Mode:Managed  Frequency:2.412 GHz  Access Point: AA:BB:CC:DD:EE:FF
          Bit Rate=5.5 Mb/s   Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Link Quality=95/100  Signal level=-34 dBm  Noise level=-127 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

I guess in kernel iwlwifi and the one from intellinuxwireless.org is not in 
sync, or there is another problem with in kernel driver? Any help is 
appreciated.

P.S: Please CC me in your reply as I am not subscribed.

-- 
Faith is believing what you know isn't so -- Mark Twain
