Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51669 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab1EDOsD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 10:48:03 -0400
Message-ID: <4DC1671C.9040906@openwrt.org> (sfid-20110504_164808_085851_38A93479)
Date: Wed, 04 May 2011 16:47:56 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Russell Senior <seniorr@aracnet.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] kernel panic on MIPS + ath5k + Wistron CM9 radio
References: <861v0igqhn.fsf@coulee.tdb.com> <86iptq8r8w.fsf@coulee.tdb.com>
In-Reply-To: <86iptq8r8w.fsf@coulee.tdb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-04 4:39 PM, Russell Senior wrote:
>>>>>>  "Russell" == Russell Senior<seniorr@aracnet.com>  writes:
>
> Russell>  Recently trying to abandon madwifi for good on some embedded
> Russell>  devices with OpenWrt, encountered kernel panics.  Same radio
> Russell>  on an x86 platform (Soekris net4826), no kernel panic.
> Russell>  Different atheros radio, no kernel panic.  Tried two
> Russell>  different MIPS boards (Netgear WGT634U and Ubiquiti
> Russell>  RouterStation), both panic'd.
>
> Russell>  Netgear WGT634U: http://pastebin.ca/2051127 Ubiquiti
> Russell>  RouterStation: http://pastebin.ca/2052610
>
> Here is another panic, this time not resulting from hostapd, but from
> an adhoc vif:
>
>    http://pastebin.ca/2053827
>
> The initial panic appears to occur in a different function from the
> hostapd initiated panics:
Again a beacon related register, this time AR5K_BEACON

- Felix
