Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:41186 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbCFMyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 07:54:43 -0500
Received: by wghl2 with SMTP id l2so16061527wgh.8
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2015 04:54:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150306125047.GB26204@w1.fi>
References: <CAGnRvurPGf1fvYs6fyrc7kttT8g3+ST_3mO5P6+mwdbU4Ay7yA@mail.gmail.com>
 <CALhHN=ofus+Uop7i8Cv7SVhmDSjA9O56xSokTr=PtmddCqczEA@mail.gmail.com>
 <CAGnRvupZGXfaf-PH2aoNYzUziFBwMw2m-Ftvx0VVysmx9NNdvQ@mail.gmail.com>
 <CALhHN=oQ99+tp2zAPmM2Tzu3WWrgtH=xnc0iqTUPVJTjyWV+Yg@mail.gmail.com> <20150306125047.GB26204@w1.fi>
From: Henning Rogge <hrogge@gmail.com>
Date: Fri, 6 Mar 2015 13:54:22 +0100
Message-ID: <CAGnRvuqjpWLvqjcdU3zF4iJ=C0CdvdFeDU8h00YKi10VuY8TPQ@mail.gmail.com> (sfid-20150306_135446_882239_B84B2DEC)
Subject: Re: State of DFS with Mac80211/ath9k
To: Jouni Malinen <j@w1.fi>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 6, 2015 at 1:50 PM, Jouni Malinen <j@w1.fi> wrote:
> On Fri, Mar 06, 2015 at 01:29:06PM +0100, Janusz Dziedzic wrote:
>> So, in case of ibss/mesh you could make wpa_supplicant dfs.c common
>> and use it (perform CAC and other operations).
>
> I actually pushed out changes yesterday to allow dfs.c/CAC to be used
> from wpa_supplicant in case of AP mode operations. I have not tried what
> would happen with mesh in similar case, but that may need changes and
> IBSS certainly would require more work for DFS.

We are using 802.11s (without multihop forwarding) instead of IBSS.

>> > Has the "802.11s support" ever been merged to wpa_supplicant?
>> >
>> > At the moment we are using neither wpa_supplicant nor hostapd... when
>> > we use encryption, we use the authsae tool from the open802.11s page.
>> >
>> I am not sure, adding Jouni here.
>
> Yes, wpa_supplicant has support for mesh BSS since November.

Do you mean IBSS or 802.11s?

Henning Rogge
