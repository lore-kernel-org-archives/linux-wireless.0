Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([87.79.32.166]:2757 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbYHEVyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 17:54:08 -0400
Message-ID: <4898CBF9.6030606@wpkg.org> (sfid-20080805_235411_377147_5E4D38DB)
Date: Tue, 05 Aug 2008 23:54:01 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Subject: Re: kernel panic on p54pci insertion on mipsel
References: <4898B018.5050202@wpkg.org>	 (sfid-20080805_220519_408842_EB7A6EEA) <1217967177.3603.60.camel@johannes.berg>
In-Reply-To: <1217967177.3603.60.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg schrieb:
>> Call Trace:[<c0060000>][<c0057150>]
> 
> My magic crystal ball says that this is not inside p54 at all, and
> indeed a problem in your kernel patches. :P

An amazingly advanced crystal ball you have ;)

So, a final update: ASUS WL-500gP (v1) running with OpenWRT patches and 
a prism54 mini-pci card:

- panics / oopses with p54pci.ko
- doesn't work with prism54.ko module (similar messages to 
http://marc.info/?l=linux-wireless&m=120250829717134&w=2)


-- 
Tomasz Chmielewski
http://wpkg.org

