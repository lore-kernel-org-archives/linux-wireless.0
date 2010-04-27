Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out04.alice.it ([85.37.17.100]:1842 "EHLO
	smtp-out04.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab0D0QDj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 12:03:39 -0400
Subject: Re: wl1251_sdio PSM
From: GNUtoo <GNUtoo@no-log.org>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1272374877.2434.0.camel@gnutoo-desktop>
References: <1272230300.2349.23.camel@gnutoo-desktop>
	 <1272232671.2349.25.camel@gnutoo-desktop>
	 <1272235632.2349.28.camel@gnutoo-desktop>
	 <1272285416.2364.1.camel@gnutoo-desktop>
	 <loom.20100427T143119-272@post.gmane.org>
	 <1272374877.2434.0.camel@gnutoo-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 18:03:33 +0200
Message-ID: <1272384213.2434.8.camel@gnutoo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-27 at 15:27 +0200, GNUtoo wrote:
> > You need a few more patches for PS to work (on top of current compat-wireless):
> > http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-kernel.git;a=commitdiff;h=8eb97a1915ae2ab0a19cc6eef1a2753b9514017d
> > http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-wifi.git;a=commitdiff;h=d16ed8871faa892f5fd4e8161412051ee11c5ecb
> > 
> > I'm working on mainline mergeable versions of those..
> Denis.
oops I don't know why the message wasn't included,maybe I made an error.
Anyway it last much longer,but sometimes it only last for about 50 pings
and after that no more network,tough iwconfig still say that it's
associated.
I'll check my hostapd router logs and try to put a wakelock

Denis.


