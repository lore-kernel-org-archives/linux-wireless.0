Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:40538 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3CFGFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 01:05:06 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20790.56369.998911.884240@gargle.gargle.HOWL> (sfid-20130306_070510_026815_489EABDC)
Date: Wed, 6 Mar 2013 11:33:29 +0530
To: Nick Thomas <nhomas@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath9k] Recent driver versions break compatibility with AR9285 for me
In-Reply-To: <CAEk6VBHnWn_KF0TJ_vojuOhWFhR6TncAok+B9mqgGzAdC5DzVg@mail.gmail.com>
References: <CAEk6VBHnWn_KF0TJ_vojuOhWFhR6TncAok+B9mqgGzAdC5DzVg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Thomas wrote:
> When I run the 3.7.10 kernel with the ath9k module loaded, the
> wireless does not work, and iwconfig wlan0 reports:
> 
> wlan0:          no wireless extensions.
> 
> When I run the 3.2.39 kernel, the wireless works, and iwconfig wlan0 reports:
> 
> wlan0     IEEE 802.11bgn  ESSID:"HardFatCox"
>           Mode:Managed  Frequency:2.437 GHz  Access Point: 00:22:75:49:42:F7
>           Bit Rate=48 Mb/s   Tx-Power=15 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:on
>           Link Quality=50/70  Signal level=-60 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:23  Invalid misc:11577   Missed beacon:0
> 
> My best guess is that recent driver revisions broke compatibility with
> my wireless card.

The card is recognized properly by ath9k, since it is shown in the interface
list and it's even associated with HardFatCox :)

What doesn't work ?

Sujith
