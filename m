Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f66.google.com ([209.85.161.66]:53079 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1ARM2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 07:28:09 -0500
Received: by mail-fx0-f66.google.com with SMTP id 14so2807840fxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 04:28:08 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/5] mac80211: add NOL functionality
Date: Tue, 18 Jan 2011 13:28:04 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201101171621.29863.bernhard.schmidt@saxnet.de> <201101181301.39953.bernhard.schmidt@saxnet.de> <1295352785.3563.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295352785.3563.15.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101181328.05515.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, January 18, 2011 13:13:05 Johannes Berg wrote:
> On Tue, 2011-01-18 at 13:01 +0100, Bernhard Schmidt wrote:
> > On Tuesday, January 18, 2011 11:43:46 Johannes Berg wrote:
> > > On Mon, 2011-01-17 at 11:05 +0100, Bernhard Schmidt wrote:
> > > > NOL is a list of channels on which radar interference has been
> > > > detected. Such channels are not allowed to be used for a
> > > > certain amount of time.
> > > 
> > > I don't think this should be implemented in mac80211.
> > 
> > In cfg80211 then? I'd really prefer to keep all flag-handling
> > together instead of splitting it up between mac80211/userspace.
> 
> Yeah, cfg80211 sounds much saner, with APIs there etc.

Ok, will move it there.

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de
