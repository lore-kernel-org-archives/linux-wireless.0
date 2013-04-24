Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sipsolutions.net ([144.76.43.152]:50101 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515Ab3DXLIe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 07:08:34 -0400
Message-ID: <1366801257.11111.21.camel@jlt4.sipsolutions.net> (sfid-20130424_130836_341933_425BD68E)
Subject: Re: How to find ESSID & signal strength
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: Arend van Spriel <arend@broadcom.com>, Kai Hendry <hendry@iki.fi>,
	Schrober <franzschrober@yahoo.de>, linux-wireless@vger.kernel.org
In-Reply-To: <87ip3c5iwi.fsf@purkki.adurom.net> (sfid-20130424_122118_008545_0C115C76)
References: <CAF8XF0cS0kY96ubMisvsm--UE1PHCzrFmRC0b1Wd5-d164EdNg@mail.gmail.com>
	 <2075657.YTpB93Bl1M@bentobox>
	 <CAF8XF0dqL_vQrGU+WYq6oa7dUt4MtN=6eGCVjBZayQqnssXS0w@mail.gmail.com>
	 <51766C1F.5010102@broadcom.com> <87ip3c5iwi.fsf@purkki.adurom.net>
	 (sfid-20130424_122118_008545_0C115C76)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Apr 2013 13:00:57 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-24 at 13:21 +0300, Kalle Valo wrote:

> I think someone should fork iw which would only provide tabular output
> for shell scripts. Shouldn't be too hard, the most difficult part is to
> make sure that the output format is extensible when adding new features.

You don't even need to fork, just send me patches :-)

Something like a --batch or --script option (to iw) would probably do
it. We'd have to teach each command to be able to do it though, so we'd
want to have some registration about whether a command is already
converted and disallow the other ones, I guess.

johannes

