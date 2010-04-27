Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out01.alice.it ([85.33.2.12]:3287 "EHLO
	smtp-out01.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab0D0QI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 12:08:28 -0400
Subject: Re: wl1251_sdio PSM
From: GNUtoo <GNUtoo@no-log.org>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1272384213.2434.8.camel@gnutoo-desktop>
References: <1272230300.2349.23.camel@gnutoo-desktop>
	 <1272232671.2349.25.camel@gnutoo-desktop>
	 <1272235632.2349.28.camel@gnutoo-desktop>
	 <1272285416.2364.1.camel@gnutoo-desktop>
	 <loom.20100427T143119-272@post.gmane.org>
	 <1272374877.2434.0.camel@gnutoo-desktop>
	 <1272384213.2434.8.camel@gnutoo-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 18:08:24 +0200
Message-ID: <1272384504.2434.9.camel@gnutoo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-27 at 18:03 +0200, GNUtoo wrote:
> On Tue, 2010-04-27 at 15:27 +0200, GNUtoo wrote:
> > > You need a few more patches for PS to work (on top of current compat-wireless):
> > > http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-kernel.git;a=commitdiff;h=8eb97a1915ae2ab0a19cc6eef1a2753b9514017d
> > > http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-wifi.git;a=commitdiff;h=d16ed8871faa892f5fd4e8161412051ee11c5ecb
> > > 
> > > I'm working on mainline mergeable versions of those..
> > Denis.
> oops I don't know why the message wasn't included,maybe I made an error.
> Anyway it last much longer,but sometimes it only last for about 50 pings
> and after that no more network,tough iwconfig still say that it's
> associated.
> I'll check my hostapd router logs and try to put a wakelock
Apr 27 18:02:18 router hostapd: wlan0: STA 00:1f:df:f8:ac:7f RADIUS:
starting accounting session 4BA21E4D-000007D8
Apr 27 18:03:24 router hostapd: wlan0: STA 00:1f:df:24:0b:7f IEEE
802.11: disassociated due to inactivity
Apr 27 18:03:25 router hostapd: wlan0: STA 00:1f:df:24:0b:7f IEEE
802.11: deauthenticated due to inactivity

So I think it's not the driver...

By the way,the thanks were lost in the mail containing only a quote and
"Denis."
so thanks a lot for the patch!!!

Denis

