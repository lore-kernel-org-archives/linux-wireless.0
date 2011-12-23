Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36770 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab1LWJDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 04:03:54 -0500
Received: by wgbdr13 with SMTP id dr13so17134151wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 01:03:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EF42F12.1000309@openwrt.org>
References: <CAApCBGx28SbbmNpynCpKW9CyAsV5+c_fZ=1k9QAsKnXf4nDQEw@mail.gmail.com>
	<CAApCBGx7fHuQr87TnppE6FyX9d-1F0huUqgYhjv++8vmfov6zQ@mail.gmail.com>
	<4EF31325.2050408@openwrt.org>
	<CAApCBGwto0YxMKcirX_FJYaGw8K6Dcoxpn9P30=Mk-9oHJok+Q@mail.gmail.com>
	<CAJ-VmonyWC4JXrikuzxxaaGMReqq3VGhH+WLWjtN+8gTCvM7kg@mail.gmail.com>
	<4EF42F12.1000309@openwrt.org>
Date: Fri, 23 Dec 2011 11:03:52 +0200
Message-ID: <CAApCBGyrF4JSEGnq0USdUT8UvmyR2kRMCFh-2nmEeRR0FTCfEw@mail.gmail.com> (sfid-20111223_100358_995732_309A3C15)
Subject: Re: ar9390 failing AGC calibration on powerpc platform
From: wireless newbie <wnewbie72@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, openwrt-devel@lists.openwrt.org,
	Mohammed Shafi <shafi.wireless@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> iw wlan0 survey dump

Here is what I got. Looks like its busy most of the time, doesn't it?

Survey data from wlan0
        frequency:                      2412 MHz
        channel active time:            139291 ms
        channel busy time:              135849 ms
        channel receive time:           0 ms
        channel transmit time:          0 ms
Survey data from wlan0
        frequency:                      2417 MHz
Survey data from wlan0
        frequency:                      2422 MHz
Survey data from wlan0
        frequency:                      2427 MHz
Survey data from wlan0
        frequency:                      2432 MHz
Survey data from wlan0
        frequency:                      2437 MHz
Survey data from wlan0
        frequency:                      2442 MHz
Survey data from wlan0
        frequency:                      2447 MHz
Survey data from wlan0
        frequency:                      2452 MHz
Survey data from wlan0
        frequency:                      2457 MHz
Survey data from wlan0
        frequency:                      2462 MHz
Survey data from wlan0
        frequency:                      5180 MHz
Survey data from wlan0
        frequency:                      5200 MHz
Survey data from wlan0
        frequency:                      5220 MHz
Survey data from wlan0
        frequency:                      5240 MHz
Survey data from wlan0
        frequency:                      5745 MHz
Survey data from wlan0
        frequency:                      5765 MHz
Survey data from wlan0
        frequency:                      5785 MHz
Survey data from wlan0
        frequency:                      5805 MHz
Survey data from wlan0
        frequency:                      5825 MHz
