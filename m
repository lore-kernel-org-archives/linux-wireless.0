Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58680 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbYCZVFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 17:05:24 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: problem with iwl4965 and kernel 2.6.24.4
Date: Wed, 26 Mar 2008 14:04:24 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004073D90@orsmsx416.amr.corp.intel.com> (sfid-20080326_210528_854829_CA3C275B)
In-Reply-To: <183c1cc10803261149r2f518772j2ea3a1b5df55b2cc@mail.gmail.com>
References: <183c1cc10803261031p6e7e16bdme000416095de9b7f@mail.gmail.com> <D936D925018D154694D8A362EEB0892004073B0C@orsmsx416.amr.corp.intel.com> <183c1cc10803261149r2f518772j2ea3a1b5df55b2cc@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "John Goulah" <jgoulah@gmail.com>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, March 26, 2008 11:49 AM, John Goulah  wrote:

> 
> $ iwconfig
> lo        no wireless extensions.
> 
> eth1      no wireless extensions.
> 
> sit0      no wireless extensions.
> 
> wmaster0  no wireless extensions.
> 
> Warning: Driver for device wlan0 has been compiled with version 22
> of Wireless Extension, while this program supports up to version 20.
> Some things may be broken... 
> 
> wlan0     IEEE 802.11  ESSID:"goulahnet"
>          Mode:Managed  Frequency:2.412 GHz  Access Point:
>          Not-Associated Tx-Power=0 dBm
>          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>          Link Quality:0  Signal level:0  Noise level:0
>          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> 
> 
> Is this warning a problem?  Does this mean I need to get a newer
> iwconfig (I'm on debian etch, Wireless-Tools version 28)

I don't know if it is necessary. In the above iwconfig output it does
not look as though you are associated though. 

> 
> Also, is this driver known to work with wpa_supplicant?

yes

Reinette
