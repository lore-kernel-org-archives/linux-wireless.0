Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm15.bullet.mail.ird.yahoo.com ([77.238.189.68]:33335 "HELO
	nm15.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755463Ab3DWKF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 06:05:56 -0400
From: Schrober <franzschrober@yahoo.de>
To: Kai Hendry <hendry@iki.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: How to find ESSID & signal strength
Date: Tue, 23 Apr 2013 12:00:07 +0200
Message-ID: <2075657.YTpB93Bl1M@bentobox> (sfid-20130423_120605_708496_0E6E2440)
In-Reply-To: <CAF8XF0cS0kY96ubMisvsm--UE1PHCzrFmRC0b1Wd5-d164EdNg@mail.gmail.com>
References: <CAF8XF0cS0kY96ubMisvsm--UE1PHCzrFmRC0b1Wd5-d164EdNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 23 April 2013 10:54:59 Kai Hendry wrote:
> Since there is no "Contact us" details upon:
> http://wireless.kernel.org/en/users/Documentation/iw
> 
> I'm nervously emailing the mailing list. :}
> 
> 
> 
> I want to please ask what is the "canonical" way using your suite of
> tools like `iw`, or preferably /proc, to find the ESSID of the AP I'm
> connected to and signal strength for my dwm status bar?
> 
> https://github.com/kaihendry/Kai-s--HOME/blob/master/bin/dwm_status#L23

"Do NOT screenscrape this tool, we don't consider its output stable."

Use nl80211
-- 
Franz Schrober
