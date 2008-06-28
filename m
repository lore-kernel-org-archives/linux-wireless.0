Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33385 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbYF1Wxl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 18:53:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: WARNING: at net/mac80211/rx.c:319 __ieee80211_rx_handle_packet+0x325/0x775()
Date: Sun, 29 Jun 2008 00:53:17 +0200
Cc: linux-wireless@vger.kernel.org, kernel-testers@vger.kernel.org
References: <4866A3A5.3060208@yahoo.com> <200806282357.30255.mb@bu3sch.de> <4866B5BF.3000404@yahoo.com>
In-Reply-To: <4866B5BF.3000404@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806290053.17284.mb@bu3sch.de> (sfid-20080629_005411_354771_864F2349)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 June 2008 00:05:51 Sitsofe Wheeler wrote:
> Michael Buesch wrote:
> > On Saturday 28 June 2008 22:48:37 Sitsofe Wheeler wrote:
> >> When I boot 2.6.26-rc8 on an x86_64 system I receive the following trace
> >> in the logs:
> >>
> >>> [   72.384009] ------------[ cut here ]------------
> >>> [   72.384021] WARNING: at net/mac80211/rx.c:319 __ieee80211_rx_handle_packet+0x325/0x775()
> > 
> > This seems to be the packet alignment warning. It's harmless
> > on your machine. You can disable it by turning off CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT.
> > 
> > However, which wireless driver do you use? This is a bug in the driver.
> 
> The intel iwl3945 driver.

That's known to be broken and is worked on.
Please simply disable the warning. It is harmless
on your machine.


-- 
Greetings Michael.
