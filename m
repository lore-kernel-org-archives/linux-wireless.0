Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35615 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1LWHeq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 02:34:46 -0500
Message-ID: <4EF42F12.1000309@openwrt.org> (sfid-20111223_083505_956260_D2A97A75)
Date: Fri, 23 Dec 2011 08:34:42 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: wireless newbie <wnewbie72@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Mohammed Shafi <shafi.wireless@gmail.com>
Subject: Re: ar9390 failing AGC calibration on powerpc platform
References: <CAApCBGx28SbbmNpynCpKW9CyAsV5+c_fZ=1k9QAsKnXf4nDQEw@mail.gmail.com> <CAApCBGx7fHuQr87TnppE6FyX9d-1F0huUqgYhjv++8vmfov6zQ@mail.gmail.com> <4EF31325.2050408@openwrt.org> <CAApCBGwto0YxMKcirX_FJYaGw8K6Dcoxpn9P30=Mk-9oHJok+Q@mail.gmail.com> <CAJ-VmonyWC4JXrikuzxxaaGMReqq3VGhH+WLWjtN+8gTCvM7kg@mail.gmail.com>
In-Reply-To: <CAJ-VmonyWC4JXrikuzxxaaGMReqq3VGhH+WLWjtN+8gTCvM7kg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-12-23 7:45 AM, Adrian Chadd wrote:
> This sounds like "noise spurs all over the place."
> 
> AGC calibration failing can be because of this.
> 
> Can you do a channel survey, or something? Felix, what can he do to
> inspect the channel busy % ?
iw wlan0 survey dump
