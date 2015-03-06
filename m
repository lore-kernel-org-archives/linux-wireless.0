Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:59005 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbbCFNA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 08:00:59 -0500
Date: Fri, 6 Mar 2015 15:00:55 +0200
From: Jouni Malinen <j@w1.fi>
To: Henning Rogge <hrogge@gmail.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: State of DFS with Mac80211/ath9k
Message-ID: <20150306130055.GA26353@w1.fi> (sfid-20150306_140102_610345_01EAC95B)
References: <CAGnRvurPGf1fvYs6fyrc7kttT8g3+ST_3mO5P6+mwdbU4Ay7yA@mail.gmail.com>
 <CALhHN=ofus+Uop7i8Cv7SVhmDSjA9O56xSokTr=PtmddCqczEA@mail.gmail.com>
 <CAGnRvupZGXfaf-PH2aoNYzUziFBwMw2m-Ftvx0VVysmx9NNdvQ@mail.gmail.com>
 <CALhHN=oQ99+tp2zAPmM2Tzu3WWrgtH=xnc0iqTUPVJTjyWV+Yg@mail.gmail.com>
 <20150306125047.GB26204@w1.fi>
 <CAGnRvuqjpWLvqjcdU3zF4iJ=C0CdvdFeDU8h00YKi10VuY8TPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGnRvuqjpWLvqjcdU3zF4iJ=C0CdvdFeDU8h00YKi10VuY8TPQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 06, 2015 at 01:54:22PM +0100, Henning Rogge wrote:
> > Yes, wpa_supplicant has support for mesh BSS since November.
> 
> Do you mean IBSS or 802.11s?

Mesh BSS is the name of the functionality that was added in the 802.11s
amendment.. "802.11s" is not really a good name to use for this taken
into account that the amendment was already merged into the current IEEE
802.11 standard.

-- 
Jouni Malinen                                            PGP id EFC895FA
