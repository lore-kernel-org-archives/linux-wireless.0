Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33246 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab1FQB4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 21:56:16 -0400
Received: by gyh3 with SMTP id 3so379037gyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2011 18:56:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=AM=mqmz7+hYGMwmVhFTHHd0o3Ug@mail.gmail.com>
References: <BANLkTi=AM=mqmz7+hYGMwmVhFTHHd0o3Ug@mail.gmail.com>
Date: Fri, 17 Jun 2011 09:56:15 +0800
Message-ID: <BANLkTin2_vQ5a9--MYhG+FhmtkYs_48f+Q@mail.gmail.com> (sfid-20110617_035619_759415_5A4A1232)
Subject: Re: can mesh(802.11s) be supported in 802.11n?
From: b z <zb80211@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nobody knows?

2011/6/15, b z <zb80211@gmail.com>:
> I have got 2 802.11n wireless routers using ralink rt3052f soc chip,mimo
> 2x2
> burned with openwrt (kernel 2.6.37.6, compat-wireless-2011-05-27)
>
> I configured them as mesh point respectively,  then
> #iw dev wlan0 station dump
>
> but the tx rate and rx rate still not exceed 54mbps, that is mean the
> ht mode(300mbps) is not been actived
>
> can anyone tell me how to active the 802.11n ht mode in mesh?
> it is the problem with mac80211 or rt2800pci driver?
> or mesh using 802.11n is not implemented in the current kernel?
>
> will it be implemented in the future?
> thank!
>
