Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:34390 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1IEKdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 06:33:32 -0400
Subject: Re: [iwl4965] Microcode SW error detected
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Bernhard Schmidt <bschmidt@freebsd.org>,
	linux-wireless@vger.kernel.org
Date: Mon, 05 Sep 2011 12:32:47 +0200
In-Reply-To: <20110905093349.GE2221@redhat.com>
References: <1306151106.2066.60.camel@x61.thuisdomein>
	 <201106070832.49048.bschmidt@freebsd.org>
	 <20110607145435.GA5179@redhat.com>
	 <1315124915.5239.21.camel@x61.thuisdomein>
	 <20110905093349.GE2221@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1315218811.4159.10.camel@t41.thuisdomein> (sfid-20110905_123335_959596_89839962)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-05 at 11:33 +0200, Stanislaw Gruszka wrote:
> On Sun, Sep 04, 2011 at 10:28:35AM +0200, Paul Bolle wrote:
> > 1) After a few days of normal usage (with quite a bit of suspend and
> > resume cycles) this error was again triggered. So avoiding
> > check_plcp_health() doesn't seem to help.
> > 
> > 2) I never send you the debug output (ie, output after doing "modprobe
> > iwl4965 debug=0x47ffffff"), did I?
> 
> No, but if error show up after few days, gathering and analyzing few
> days of debug logs in impractical.

I see.

> Does wifi stop working after an
> error, or there is some other negative impact? Or only that messages
> are printed and driver recover itself?

There doesn't seem to be any impact (ie, it might have some impact but
I'm too insensitive to notice). The driver does recover itself and I do
not have to mess with rfkill or "modprobe -r" or whatever. I actually
discovered this because I tend to regularly do
    dmesg -r |  grep "^<[123]>"

to keep myself informed of any kernel errors (or worse). And then these
few dozen lines can't go unnoticed.


Paul Bolle

