Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18154 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab2DYBva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 21:51:30 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-ID: <20375.22656.459433.717064@gargle.gargle.HOWL> (sfid-20120425_035211_486031_C7A87AE6)
Date: Wed, 25 Apr 2012 07:20:56 +0530
To: Aseem Sharma <aseem.sharma19@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Survey dump does not seem to work with SONY USB Wireless LAN Adapter UWA-BR100
In-Reply-To: <CANK3ZEczOgsru2BZ=sLnYxx_3St872y0-qAbYBV-PkhpNioNxQ@mail.gmail.com>
References: <CANK3ZEcGEs6xSn8tgniXCGVN50VadYaY2ZvV0Fis236O19nqNQ@mail.gmail.com>
	<CANK3ZEczOgsru2BZ=sLnYxx_3St872y0-qAbYBV-PkhpNioNxQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Aseem Sharma wrote:
> Hello,
> 
> I was previously using Cisco Aironet wireless adapter (it uses ath5k
> driver); using which I was able to get the survey dump using the following
> command:
> 
> root@as75:~# iw phy phy0 interface add mon0 type monitor
> root@as75:~# ifconfig mon0 up
> root@as75:~# iw dev mon0 survey dump
> 
> Survey data from mon0
>         frequency:                      2412 MHz
>         noise:                          -95 dBm
>         channel active time:            11813 ms
>         channel busy time:              300 ms
>         channel receive time:           237 ms
>         channel transmit time:          0 ms
> 
> However, when I run the same commands after connecting SONY USB Wireless
> LAN Adapter UWA-BR100 (which internally uses ath9k_htc driver) I do not seem
> to get any output. Also, the command is successful (as I am running echo $?
> which returns ‘0’)

ath9k_htc currently doesn't support survey dump.

Sujith
