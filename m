Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60136 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab1LUAqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 19:46:34 -0500
Subject: Re: linux 3.2-rcX iwlwifi driver's problem (wifi link unstable
 when moving between multiple APs)
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Cheng Renquan <crquan@gmail.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com>
References: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Dec 2011 15:46:05 -0800
Message-ID: <1324424765.13074.281.camel@wwguy-huron> (sfid-20111221_014638_653445_B17B5587)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Renquan,

Thanks you for reporting the issue.It will be greatly appreciated  if
you can enter a bug report in http://bugzilla.intellinuxwireless.org/.
Then we can assign engineer to look into the issue , also keep track of
the progress.

Thanks
Wey

On Tue, 2011-12-20 at 15:20 -0800, Cheng Renquan wHi Intel Linux
Wireless group,
> 
> Since 3.2-rcX, it seems no more iwlagn driver? This iwlwifi driver
> seems not stable
> when I hold laptop moving inside a large office, between multiple APs,
> everytime I moved to a new place, the wifi link becomes inactive, and
> I need to wait
> 5 minutes or longer to wait iwlwifi stable, networkmanager get a new
> ip address; quite annoying,
> 
> 
> [root@archtop ~]# lspci -D -nn -k -d 8086:4238
> 0000:03:00.0 Network controller [0280]: Intel Corporation Centrino
> Ultimate-N 6300 [8086:4238] (rev 35)
> 	Subsystem: Intel Corporation Centrino Ultimate-N 6300 3x3 AGN [8086:1111]
> 	Kernel driver in use: iwlwifi
> 	Kernel modules: iwlwifi
> 
> in the large office, it's using WPA2 enterprise encryption with
> MSCHAPv2 domain user/pass authentication,
> 
> 
> Last iwlagn driver in my Ubuntu-10.10 default kernel (linux-2.6.35.X)
> on the same computer
> same networkmanager/wpa_supplicant software same office working wonderful,
> moving smoothly between multiple APs,
> 
> At home, even I set wireless router to no any
> encryption/authentication, this new kernel
> would becomes wifi link down every couple of hours, while another
> laptop and same Ubuntu-10
> on this laptop could work smoothly,
> 
> 
> 
> 
> Thanks,


