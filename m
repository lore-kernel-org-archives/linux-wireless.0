Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:61162 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZBOUqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 15:46:10 -0500
Received: by fxm13 with SMTP id 13so5137331fxm.13
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 12:46:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090215154408.GA6845@jm.kir.nu>
References: <20090213105306.GA18754@jm.kir.nu>
	 <1234522804.4219.13.camel@johannes.local>
	 <20090213111523.GA22438@jm.kir.nu>
	 <1ba2fa240902150509i5df08adcg214901548d3cd538@mail.gmail.com>
	 <20090215154408.GA6845@jm.kir.nu>
Date: Sun, 15 Feb 2009 22:40:35 +0200
Message-ID: <1ba2fa240902151240v3bbe2885l4ef4d90e5d78b0a7@mail.gmail.com> (sfid-20090215_214613_307475_F326D576)
Subject: Re: [PATCH] nl80211: Optional IEs into scan request
From: Tomas Winkler <tomasw@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 15, 2009 at 5:44 PM, Jouni Malinen <j@w1.fi> wrote:
> On Sun, Feb 15, 2009 at 03:09:15PM +0200, Tomas Winkler wrote:
>> Status questions
>> What is the version of wpa_supplicant that supports WPS.  Is wext
>> covered with IWEVGENIE?
>
> wpa_supplicant 0.6.7 and newer has support for WPS, but there are some
> bug fixes since then, so 0.6.8 is likely a better starting point. wext
> works for most parts, but there is no support for adding WPS IE into
> Probe Request with it (cfg80211/nl80211 needed for this). Anyway, that
> part of the protocol is optional, so it should not cause major problems.
>
>> Is it currently working with mac80211 based drivers?
>
> Yes.
>
Thanks
Tomas
> --
> Jouni Malinen                                            PGP id EFC895FA
>
