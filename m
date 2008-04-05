Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:35174 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYDENhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 09:37:52 -0400
Received: by el-out-1112.google.com with SMTP id v27so345612ele.17
        for <linux-wireless@vger.kernel.org>; Sat, 05 Apr 2008 06:37:51 -0700 (PDT)
Message-ID: <1ba2fa240804050637g13a92505j5d4d65234db8c6fc@mail.gmail.com> (sfid-20080405_143803_999924_03C5D19A)
Date: Sat, 5 Apr 2008 16:37:50 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Bachman Kharazmi" <bachman@tor.lindesign.se>
Subject: Re: compat-wireless iwl4965 on hp/compaq 2510p
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <47F76A0A.3080806@tor.lindesign.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47F75EB4.9090703@tor.lindesign.se>
	 <1207396223.3860.9.camel@johannes.berg>
	 <47F76814.7010405@tor.lindesign.se>
	 <1207396488.3860.12.camel@johannes.berg>
	 <47F76A0A.3080806@tor.lindesign.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 5, 2008 at 3:01 PM, Bachman Kharazmi
<bachman@tor.lindesign.se> wrote:
> lapp:/tmp# ip link set wlan0 up
>  SIOCSIFFLAGS: No such device
>
>  lapp:/tmp# iwconfig
>  lo        no wireless extensions.
>
>  eth1      no wireless extensions.
>
>  wmaster0  no wireless extensions.
>
>  wlan0     IEEE 802.11  ESSID:"planet_mars"
>           Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
>           Tx-Power=0 dBm
>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>           Encryption key:B200-A927-32DA-86E9-0DEF-EFF3-FB
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
>
>  note that dmesg sais
>  iwl4965: Detected Intel Wireless WiFi Link 4965AGN
>  iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
>  phy1: Selected rate control algorithm 'iwl-4965-rs'
>  ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
>  iwl4965: Radio disabled by HW RF Kill switch

___iwl4965: Radio disabled by HW RF Kill switch___  this would explain
the problem

can you please enable the RF?
