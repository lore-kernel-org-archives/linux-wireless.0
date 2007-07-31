Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45945 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752467AbXGaVMw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 17:12:52 -0400
Date: Tue, 31 Jul 2007 23:12:49 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Message-ID: <20070731231249.121d55d4@logostar.upir.cz>
In-Reply-To: <46AE7361.90406@warmcat.com>
References: <20070730023128.99E927B409F@zog.reactivated.net>
	<20070730145125.GC6586@tuxdriver.com>
	<20070730225205.GA17252@deine-taler.de>
	<200707310105.55863.mb@bu3sch.de>
	<46AE7361.90406@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 31 Jul 2007 00:25:21 +0100, Andy Green wrote:
> The "soft" one is a faked up repeating of incoming (and outgoing!
> twice!) packets

You mean you see each outgoing packet twice on soft monitor interface? That
would be a bug.

> It really would be much better if the device
> is kicked to hardware promisc if ANY virtual interface is in Monitor
> mode, therefore the results are consistent regardless of the number of
> virtual interfaces that happen to be around.

Of course. If the hardware supports that.

 Jiri

-- 
Jiri Benc
SUSE Labs
