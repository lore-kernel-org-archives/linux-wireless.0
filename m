Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:58998 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097AbbCFMuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 07:50:50 -0500
Date: Fri, 6 Mar 2015 14:50:47 +0200
From: Jouni Malinen <j@w1.fi>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Henning Rogge <hrogge@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: State of DFS with Mac80211/ath9k
Message-ID: <20150306125047.GB26204@w1.fi> (sfid-20150306_135103_063099_0D2963D6)
References: <CAGnRvurPGf1fvYs6fyrc7kttT8g3+ST_3mO5P6+mwdbU4Ay7yA@mail.gmail.com>
 <CALhHN=ofus+Uop7i8Cv7SVhmDSjA9O56xSokTr=PtmddCqczEA@mail.gmail.com>
 <CAGnRvupZGXfaf-PH2aoNYzUziFBwMw2m-Ftvx0VVysmx9NNdvQ@mail.gmail.com>
 <CALhHN=oQ99+tp2zAPmM2Tzu3WWrgtH=xnc0iqTUPVJTjyWV+Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALhHN=oQ99+tp2zAPmM2Tzu3WWrgtH=xnc0iqTUPVJTjyWV+Yg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 06, 2015 at 01:29:06PM +0100, Janusz Dziedzic wrote:
> So, in case of ibss/mesh you could make wpa_supplicant dfs.c common
> and use it (perform CAC and other operations).

I actually pushed out changes yesterday to allow dfs.c/CAC to be used
from wpa_supplicant in case of AP mode operations. I have not tried what
would happen with mesh in similar case, but that may need changes and
IBSS certainly would require more work for DFS.

> > Has the "802.11s support" ever been merged to wpa_supplicant?
> >
> > At the moment we are using neither wpa_supplicant nor hostapd... when
> > we use encryption, we use the authsae tool from the open802.11s page.
> >
> I am not sure, adding Jouni here.

Yes, wpa_supplicant has support for mesh BSS since November.

-- 
Jouni Malinen                                            PGP id EFC895FA
