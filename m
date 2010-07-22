Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54184 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab0GVW4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 18:56:46 -0400
Received: by ewy23 with SMTP id 23so3143209ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 15:56:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C4791AF.8040909@openwrt.org>
References: <AANLkTimQ7O2nOmh2Rda3d_PKWbS2WlGVBHYMCuhxW10W@mail.gmail.com>
	<4C4791AF.8040909@openwrt.org>
Date: Fri, 23 Jul 2010 00:56:43 +0200
Message-ID: <AANLkTimGvPtolVncEu_csK22xvf1SIFFPusCSqxYiU-A@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k: performance regressions / tx semi-stuck
	somehow
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/7/22 Felix Fietkau <nbd@openwrt.org>:
> On 2010-07-22 12:17 AM, Björn Smedman wrote:
>> Hi all,
>>
>> I just tried out compat-wireless-2010-07-16 on AR913x (with
>> openwrt/trunk@r22321) and saw some weird performance problems.
>>
> Could you please try if the earlier version that was in OpenWrt
> (2010-07-06) has the same issues?
>

Quickly flashing the builds I have on hand I came up with this small
table comparing MacBook 11g and 11n clients for various openwrt/trunk
versions:

r21960P (compat-wireless-2010-06-15): 11g = 12Mbps, 11n = 7.2Mbps
r22286 (compat-wireless-2010-07-06): 11g = 7.2Mbps*, 11n = 4.2Mbps*
r22321 (compat-wireless-2010-07-16): 11g = 12Mbps*, 11n = 2.9Mbps*

(*) Bursty / unstable performance.
(P) Some patches of my own on top of openwrt.

I realize it doesn't say very much unfortunately...

/Björn
