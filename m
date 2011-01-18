Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f66.google.com ([209.85.161.66]:53079 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab1ARM2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 07:28:07 -0500
Received: by fxm14 with SMTP id 14so2807840fxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 04:28:06 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/5] mac80211: add DFS related channel flags
Date: Tue, 18 Jan 2011 13:27:38 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201101171621.29863.bernhard.schmidt@saxnet.de> <201101181259.46719.bernhard.schmidt@saxnet.de> <1295352973.3563.16.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295352973.3563.16.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101181328.04540.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, January 18, 2011 13:16:13 Johannes Berg wrote:
> On Tue, 2011-01-18 at 12:59 +0100, Bernhard Schmidt wrote:
> > > I'm not sure about this -- shouldn't that be global information?
> > > If one device in the system records a radar on the channel, it
> > > surely applies to other devices as well, even if they are
> > > hot-plugged after the radar was found?
> > 
> > True, I've based this on our IRC discussions, the consensus there
> > was to do it per-wiphy only at first.
> 
> I thought what we had discussed there (but I missed at least one
> meeting) was that the *detector* state, for software-based detection,
> should be per wiphy. I never heard anywhere that the result of that
> should be local too.

Hmm, ok, I might have got that wrong. We should discuss this today on 
IRC and whatever the consensus is, I will adjust the code.

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de
