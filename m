Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51013 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805Ab1ENAG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 20:06:57 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p4E06ui5019884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 17:06:57 -0700
Message-ID: <4DCDC7A0.2020504@candelatech.com> (sfid-20110514_020759_726744_B04DBCFC)
Date: Fri, 13 May 2011 17:06:56 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Can't get hostapd to start, channels are all passive-scanning?
References: <4DCDC068.9060307@candelatech.com>
In-Reply-To: <4DCDC068.9060307@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/13/2011 04:36 PM, Ben Greear wrote:
> Any idea what would cause all of my 5Ghz channels to be passive
> scanning (which keeps hostapd from being able to use them, evidently)
>
> Frequencies:
> * 5180 MHz [36] (17.0 dBm) (passive scanning, no IBSS)
> * 5200 MHz [40] (17.0 dBm) (passive scanning, no IBSS)
> * 5220 MHz [44] (17.0 dBm) (passive scanning, no IBSS)
> * 5240 MHz [48] (17.0 dBm) (passive scanning, no IBSS)
> * 5260 MHz [52] (18.0 dBm) (passive scanning, no IBSS, radar detection)
> * 5280 MHz [56] (18.0 dBm) (passive scanning, no IBSS, radar detection)
> * 5300 MHz [60] (18.0 dBm) (passive scanning, no IBSS, radar detection)
> * 5320 MHz [64] (18.0 dBm) (passive scanning, no IBSS, radar detection)

Bleh...reboot and it comes up looking more normal (first 4 are usable, at least).

Will post again if I can reproduce it.

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

