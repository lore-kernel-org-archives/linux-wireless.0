Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48740 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbYJUHUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 03:20:39 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 00:20:39 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18685.33329.121235.399812@gargle.gargle.HOWL> (sfid-20081021_092044_490260_611B979A)
Date: Tue, 21 Oct 2008 12:48:09 +0530
To: Tomas Winkler <tomasw@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
In-Reply-To: <1ba2fa240810201446x429e0b5aud3f20e2fadb19f1@mail.gmail.com>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	<1224491480.18024.32.camel@johannes.berg>
	<18684.18492.94865.480736@gargle.gargle.HOWL>
	<1224493957.18024.47.camel@johannes.berg>
	<18684.20459.335157.171344@gargle.gargle.HOWL>
	<1224495531.18024.55.camel@johannes.berg>
	<18684.24323.743610.871307@gargle.gargle.HOWL>
	<1224505349.27899.17.camel@johannes.berg>
	<18684.51206.771543.514682@localhost.localdomain>
	<1ba2fa240810201446x429e0b5aud3f20e2fadb19f1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> We may fit into this schema, just some of the book keeping tasks here
> we have off loaded to the hw.
> 

Can you explain a bit more about what is offloaded exactly ?

> > Immediate Block-Ack is mandatory for 11n, delayed BA is optional.
> > ath9k currently maintains the BA window state internally too.
> > Another candidate that can be moved to mac80211, IMO.
> >
> 
> TX or RX side?
> 

ath9k maintains BA state for both RX and TX currently.

Sujith
