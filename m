Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51575 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaKYPRq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 10:17:46 -0500
Message-ID: <1416928659.2045.8.camel@sipsolutions.net> (sfid-20141125_161749_633505_888F4D0B)
Subject: Re: [PATCH] mac80211: check if channels allow 80 MHz for VHT probe
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: YanBo <dreamfly281@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, j@w1.fi,
	Kalle Valo <kvalo@qca.qualcomm.com>
Date: Tue, 25 Nov 2014 16:17:39 +0100
In-Reply-To: <CAFuUQkibQ0o5H=5b4ZQyiadiPuoU8gY+5pg9TyqKLzMvV3q2SA@mail.gmail.com> (sfid-20141125_154908_659671_DFA9C862)
References: <CAFuUQkibQ0o5H=5b4ZQyiadiPuoU8gY+5pg9TyqKLzMvV3q2SA@mail.gmail.com>
	 (sfid-20141125_154908_659671_DFA9C862)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Agree with you that it need a bigger discussion about whether
> advertise VHT is the suitable/best
> way to support the  VHT at 2.4G feature.
> 
> We are considered this ways as it is already be used by some vendor
> like BRCM or Qualcomm Atheros
> in there full mac product, and there will be IOT issue if there are
> kinds of different implementation.

There's no forum that defines it and tests IOP though...

johannes

