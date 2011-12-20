Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56948 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1LTXU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 18:20:26 -0500
Received: by werm1 with SMTP id m1so2332434wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 15:20:25 -0800 (PST)
MIME-Version: 1.0
From: Cheng Renquan <crquan@gmail.com>
Date: Tue, 20 Dec 2011 15:20:04 -0800
Message-ID: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com> (sfid-20111221_002030_180161_4157390A)
Subject: linux 3.2-rcX iwlwifi driver's problem (wifi link unstable when
 moving between multiple APs)
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Intel Linux Wireless group,

Since 3.2-rcX, it seems no more iwlagn driver? This iwlwifi driver
seems not stable
when I hold laptop moving inside a large office, between multiple APs,
everytime I moved to a new place, the wifi link becomes inactive, and
I need to wait
5 minutes or longer to wait iwlwifi stable, networkmanager get a new
ip address; quite annoying,


[root@archtop ~]# lspci -D -nn -k -d 8086:4238
0000:03:00.0 Network controller [0280]: Intel Corporation Centrino
Ultimate-N 6300 [8086:4238] (rev 35)
	Subsystem: Intel Corporation Centrino Ultimate-N 6300 3x3 AGN [8086:1111]
	Kernel driver in use: iwlwifi
	Kernel modules: iwlwifi

in the large office, it's using WPA2 enterprise encryption with
MSCHAPv2 domain user/pass authentication,


Last iwlagn driver in my Ubuntu-10.10 default kernel (linux-2.6.35.X)
on the same computer
same networkmanager/wpa_supplicant software same office working wonderful,
moving smoothly between multiple APs,

At home, even I set wireless router to no any
encryption/authentication, this new kernel
would becomes wifi link down every couple of hours, while another
laptop and same Ubuntu-10
on this laptop could work smoothly,




Thanks,
