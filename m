Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36347 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbcAEJ7C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 04:59:02 -0500
Message-ID: <1451987939.12357.18.camel@sipsolutions.net> (sfid-20160105_105906_880481_B64AE240)
Subject: Re: Mac80211 : Wpa rekeying issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias May <matthias.may@neratec.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jan 2016 10:58:59 +0100
In-Reply-To: <568B912F.8070100@neratec.com>
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>
	 <CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>
	 <0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>
	 <0a6a01d143a2$fcb77720$f6266560$@acksys.fr>
	 <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com>
	 <568B912F.8070100@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-05 at 10:47 +0100, Matthias May wrote:

> 
> We've encountered exactly this problem in a mix of devices where one 
> applies key material faster than the other. (ath9k and aquilla)
> As a workaround we check on the STA if we are authorized when 
> updating/checking CCMP. (see attached patches)
> 

Those don't really seem safe to use either.

johannes
