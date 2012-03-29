Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.polymtl.ca ([132.207.4.11]:57900 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab2C2MiY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 08:38:24 -0400
Message-ID: <1333024700.4f7457bc869f2@www.imp.polymtl.ca> (sfid-20120329_143827_970000_992B9EA0)
Date: Thu, 29 Mar 2012 08:38:20 -0400
From: Naveen Goswamy <naveen.goswamy@polymtl.ca>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac TCP problems and txop exceeded
References: <1332866581.4f71ee152ce84@www.imp.polymtl.ca> <4F71F3E5.6030105@broadcom.com> <1332870459.4f71fd3bb7453@www.imp.polymtl.ca> <4F74509A.3060103@broadcom.com>
In-Reply-To: <4F74509A.3060103@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


BTW, broadcom-sta works fine with older 2.6 kernels.  Here is an example of
iwconfig's output with the broadcom-sta driver and 2.6.36



eth1      IEEE 802.11  ESSID:"MMM"  Nickname:""
          Mode:Managed  Frequency:2.412 GHz  Access Point: 00:AA:D1:64:DF:5B
          Bit Rate=54 Mb/s   Tx-Power:24 dBm
          Retry min limit:7   RTS thr:off   Fragment thr:off
          Power Managementmode:All packets received
          Link Quality=4/5  Signal level=-64 dBm  Noise level=-98 dBm
          Rx invalid nwid:0  Rx invalid crypt:11  Rx invalid frag:0
          Tx excessive retries:1  Invalid misc:0   Missed beacon:0

and when using 3.2.1 and brcmsmac I get

wlan0     IEEE 802.11bgn  ESSID:"MMM"
          Mode:Managed  Frequency:2.412 GHz  Access Point: 00:AA:D1:64:DF:5B
          Bit Rate=1 Mb/s   Tx-Power=19 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=54/70  Signal level=-56 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:1  Invalid misc:7   Missed beacon:0



