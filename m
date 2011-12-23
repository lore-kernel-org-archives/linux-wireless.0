Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63625 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1LWGpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 01:45:25 -0500
Received: by vcbfk14 with SMTP id fk14so7113616vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 22:45:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAApCBGwto0YxMKcirX_FJYaGw8K6Dcoxpn9P30=Mk-9oHJok+Q@mail.gmail.com>
References: <CAApCBGx28SbbmNpynCpKW9CyAsV5+c_fZ=1k9QAsKnXf4nDQEw@mail.gmail.com>
	<CAApCBGx7fHuQr87TnppE6FyX9d-1F0huUqgYhjv++8vmfov6zQ@mail.gmail.com>
	<4EF31325.2050408@openwrt.org>
	<CAApCBGwto0YxMKcirX_FJYaGw8K6Dcoxpn9P30=Mk-9oHJok+Q@mail.gmail.com>
Date: Thu, 22 Dec 2011 22:45:24 -0800
Message-ID: <CAJ-VmonyWC4JXrikuzxxaaGMReqq3VGhH+WLWjtN+8gTCvM7kg@mail.gmail.com> (sfid-20111223_074529_381168_74F58782)
Subject: Re: ar9390 failing AGC calibration on powerpc platform
From: Adrian Chadd <adrian@freebsd.org>
To: wireless newbie <wnewbie72@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, openwrt-devel@lists.openwrt.org,
	Mohammed Shafi <shafi.wireless@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This sounds like "noise spurs all over the place."

AGC calibration failing can be because of this.

Can you do a channel survey, or something? Felix, what can he do to
inspect the channel busy % ?



Adrian
