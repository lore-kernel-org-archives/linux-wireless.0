Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coco.cs.washington.edu ([128.208.3.82]:39015 "EHLO
	coco.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab0CCUbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 15:31:23 -0500
Subject: Re: [ipw3945-devel] iwl4965: 11a channels disabled in current wireless-testing
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Daniel Halperin <dhalperi@cs.washington.edu>
In-Reply-To: <1267640304.15761.121.camel@rchatre-DESK>
Date: Wed, 3 Mar 2010 12:14:01 -0800
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Message-Id: <03690D90-3C5E-4E37-8BC6-7EE6FE0B4E1D@cs.washington.edu>
References: <201002281534.11656.helmut.schaa@googlemail.com> <201003011927.53208.helmut.schaa@googlemail.com> <43e72e891003011059v564931e2qfe390657b698c277@mail.gmail.com> <201003022047.10196.helmut.schaa@googlemail.com> <1267640304.15761.121.camel@rchatre-DESK>
To: reinette chatre <reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mar 3, 2010, at 10:18 AM, reinette chatre wrote:
> 	Band 2:
> [...]
> 		Frequencies:
> 			* 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)
> 			* 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)
> 			* 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)
> 			* 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)
> 			* 5260 MHz [52] (disabled)
> 			* 5280 MHz [56] (disabled)
> 			* 5300 MHz [60] (disabled)
> 			* 5320 MHz [64] (disabled)
> 			* 5500 MHz [100] (disabled)
> 			* 5520 MHz [104] (disabled)
> 			* 5540 MHz [108] (disabled)
> 			* 5560 MHz [112] (disabled)
> 			* 5580 MHz [116] (disabled)
> 			* 5600 MHz [120] (disabled)
> 			* 5620 MHz [124] (disabled)
> 			* 5640 MHz [128] (disabled)
> 			* 5660 MHz [132] (disabled)
> 			* 5680 MHz [136] (disabled)
> 			* 5700 MHz [140] (disabled)

Is this really correct? With some update between now and a while ago (October?) I can no longer even monitor on most 11a channels. (E.g., "iwconfig wlan0 mode monitor ; iwconfig wlan0 channel 64" returns an error). This was not the old behavior, and seems to be wrong to me.

Dan