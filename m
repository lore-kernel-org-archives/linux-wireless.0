Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40977 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2DYAoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 20:44:15 -0400
Received: by iadi9 with SMTP id i9so1713268iad.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 17:44:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANK3ZEcGEs6xSn8tgniXCGVN50VadYaY2ZvV0Fis236O19nqNQ@mail.gmail.com>
References: <CANK3ZEcGEs6xSn8tgniXCGVN50VadYaY2ZvV0Fis236O19nqNQ@mail.gmail.com>
Date: Tue, 24 Apr 2012 17:44:14 -0700
Message-ID: <CANK3ZEczOgsru2BZ=sLnYxx_3St872y0-qAbYBV-PkhpNioNxQ@mail.gmail.com> (sfid-20120425_024418_641933_D406883B)
Subject: Re: Survey dump does not seem to work with SONY USB Wireless LAN
 Adapter UWA-BR100
From: Aseem Sharma <aseem.sharma19@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I was previously using Cisco Aironet wireless adapter (it uses ath5k
driver); using which I was able to get the survey dump using the following
command:

root@as75:~# iw phy phy0 interface add mon0 type monitor
root@as75:~# ifconfig mon0 up
root@as75:~# iw dev mon0 survey dump

Survey data from mon0
        frequency:                      2412 MHz
        noise:                          -95 dBm
        channel active time:            11813 ms
        channel busy time:              300 ms
        channel receive time:           237 ms
        channel transmit time:          0 ms

However, when I run the same commands after connecting SONY USB Wireless
LAN Adapter UWA-BR100 (which internally uses ath9k_htc driver) I do not seem
to get any output. Also, the command is successful (as I am running echo $?
which returns ‘0’)

My questions:
1. Is there any other command or proc/sys interface from where I can
retreive this information?
2. Is there any other command option that I can use to retreive this
information?
3. Is there a patch for the above said driver that I can use?

Any help will be really appreciated.

Thanks in advance,
Aseem
(Newbie with Linux drivers)
