Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:41523 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZG2Hp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 03:45:27 -0400
Received: by fg-out-1718.google.com with SMTP id e21so158535fga.17
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 00:45:26 -0700 (PDT)
To: chris2553@googlemail.com
Cc: Luis Correia <luis.f.correia@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
	<c6b1100b0907280634j4610d077rb30f1f571aac7f36@mail.gmail.com>
	<efe7343f0907280638i12b0bb4bq237ca4f6376eb1fe@mail.gmail.com>
	<200907290803.46110.chris2553@googlemail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 29 Jul 2009 10:45:21 +0300
In-Reply-To: <200907290803.46110.chris2553@googlemail.com> (Chris Clayton's message of "Wed\, 29 Jul 2009 08\:03\:46 +0100")
Message-ID: <87bpn4oru6.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chris Clayton <chris2553@sky.com> writes:

> 4. Are there any plans to be able to switch power-saving on/off on a
> driver-by-driver basis. It seems to me, although I'm happy to be
> corrected, that it is either on or off for a given kernel, depending
> on CONFIG_MAC80211_DEFAULT_PS.

mac80211 drivers can control power save with IEEE80211_HW_SUPPORTS_PS
flag. Also it can runtime from user space with 'iwconfig wlan0 power
off'. nl80211 interface is on my todo list.

-- 
Kalle Valo
