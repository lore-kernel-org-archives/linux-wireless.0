Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42462 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2ARMKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 07:10:07 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20246.46742.295455.729628@gargle.gargle.HOWL> (sfid-20120118_131013_016042_09C661A6)
Date: Wed, 18 Jan 2012 17:39:58 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Jonathan Bagg <jbagg@lenbrook.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: ath6kl in compat wireless supports AP mode?
In-Reply-To: <4F16AF8D.6070201@qca.qualcomm.com>
References: <4F10AA2D.1060000@lenbrook.com>
	<4F16AF8D.6070201@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> Hi Jonathan,
> 
> sorry for answering late.
> 
> On 01/14/2012 12:03 AM, Jonathan Bagg wrote:
> > Anybody know if the ath6kl driver in compat wireless supports AP mode?
> > 
> > hostapd hostapd.conf
> > nl80211: Failed to set interface wlan0 into AP mode
> > nl80211 driver initialization failed.
> > 
> > hostapd.conf
> > interface=wlan0
> > driver=nl80211
> > ssid=test
> > channel=1
> > 
> > Using
> > hostapd v0.7.3
> > libnl-2.0
> 
> Most of the ath6kl developers use wpasupplicants AP mode for this so I
> recommend trying with wpasupplicant first. It might be that hostapd
> requires something which ath6kl doesn't support.

hostapd works fine, but a recent git version is probably required.
v0.7.3 is a bit old, I think.

Sujith
