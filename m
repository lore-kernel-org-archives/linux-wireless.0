Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31958 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab2ARLkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 06:40:08 -0500
Message-ID: <4F16AF8D.6070201@qca.qualcomm.com> (sfid-20120118_124015_909120_A36891CE)
Date: Wed, 18 Jan 2012 13:39:57 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jonathan Bagg <jbagg@lenbrook.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: ath6kl in compat wireless supports AP mode?
References: <4F10AA2D.1060000@lenbrook.com>
In-Reply-To: <4F10AA2D.1060000@lenbrook.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jonathan,

sorry for answering late.

On 01/14/2012 12:03 AM, Jonathan Bagg wrote:
> Anybody know if the ath6kl driver in compat wireless supports AP mode?
> 
> hostapd hostapd.conf
> nl80211: Failed to set interface wlan0 into AP mode
> nl80211 driver initialization failed.
> 
> hostapd.conf
> interface=wlan0
> driver=nl80211
> ssid=test
> channel=1
> 
> Using
> hostapd v0.7.3
> libnl-2.0

Most of the ath6kl developers use wpasupplicants AP mode for this so I
recommend trying with wpasupplicant first. It might be that hostapd
requires something which ath6kl doesn't support.

Kalle
