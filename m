Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37944 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3DMO3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Apr 2013 10:29:23 -0400
Received: by mail-wg0-f44.google.com with SMTP id a12so126141wgh.11
        for <linux-wireless@vger.kernel.org>; Sat, 13 Apr 2013 07:29:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365849071-2389-1-git-send-email-jogo@openwrt.org>
References: <1365849071-2389-1-git-send-email-jogo@openwrt.org>
Date: Sat, 13 Apr 2013 07:29:22 -0700
Message-ID: <CAJ-VmokacZUw1Wru_0w1XaVRoZWP6nOMcdKo=1yhP-C9rbifHg@mail.gmail.com> (sfid-20130413_162928_260950_E23BA078)
Subject: Re: [RFC/RFT] mwl8k: don't expose non-standard rates
From: Adrian Chadd <adrian@freebsd.org>
To: Jonas Gorski <jogo@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 13 April 2013 03:31, Jonas Gorski <jogo@openwrt.org> wrote:
> Do not advertise the non standard rates 22 Mbps and 72 Mbps to mac80211,
> they will make it into the probe responses and cause clients checking them
> to refuse association, e.g. wpa_supplicant says:

Are these "turbo" mode rates? ie, 40MHz wide channels with pre-11n
rates on them?



Adrian
