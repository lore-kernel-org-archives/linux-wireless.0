Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61622 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaHCQG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2014 12:06:26 -0400
Received: by mail-oa0-f44.google.com with SMTP id eb12so4306591oac.17
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2014 09:06:26 -0700 (PDT)
Message-ID: <53DE5E00.1020104@lwfinger.net> (sfid-20140803_180634_810618_5599835E)
Date: Sun, 03 Aug 2014 11:06:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Borislav Boev <borislavboev@hotmail.com>,
	Johannes Stezenbach <js@sig21.net>,
	Nate Carlson <linux-wireless@natecarlson.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: Poor wifi performance on Intel 7260 Dual-Band AC Wifi card
References: <BAY178-W38CA42DFDD4031D453FB48CFF80@phx.gbl>,<53D7AEF5.5040907@lwfinger.net>,<alpine.DEB.2.02.1407290946100.1431@admin.chi.technicality.org>,<20140730110829.GA3563@sig21.net> <BAY178-W352D0CFD0088C05127F92ECFE50@phx.gbl>
In-Reply-To: <BAY178-W352D0CFD0088C05127F92ECFE50@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/03/2014 04:45 AM, Borislav Boev wrote:
> Okay, here's another 'workaround' (though I haven't tested it more than one day yet)
> Wifi performance seems to be better & stronger when I changed my network's broadcast channel (It was on auto select before, now I changed it to channel 11 - 2462mhz). I'm living in a populated area, there's a lot of wifi networks around, so that could be one of the problems, I bet most of them are on auto-channel and cheap routers aren't that good in selecting the best frequency, so there's a lot of interference between networks.
> The good thing so far is that I'm back on my wireless-N speeds. Will report if something goes wrong.

For what it is worth, I never let my router pick a channel using "auto". Most of
my neighbors are on channel 6, thus I use 1 or 11.

Larry


