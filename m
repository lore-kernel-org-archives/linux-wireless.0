Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:33368 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751750Ab1AXBK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 20:10:28 -0500
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0627811424
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 10:10:26 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH] cfg80211: report monitor interface channel via wext when possible
Date: Mon, 24 Jan 2011 10:10:38 +0900
Cc: Paul Fertser <fercerpav@gmail.com>, linux-wireless@vger.kernel.org,
	"Thomas d'Otreppe" <tdotreppe@gmail.com>,
	Richard Farina <sidhayn@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <1295655098-17534-1-git-send-email-fercerpav@gmail.com> <1295773599.3639.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295773599.3639.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101241010.38393.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun January 23 2011 18:06:39 Johannes Berg wrote:
> On Sat, 2011-01-22 at 03:11 +0300, Paul Fertser wrote:
> > This makes it possible to retrieve the channel for the monitor interface
> > in cases when it can be determined unambigously. Tested with ath5k.
> 
> NAK.
> 
> http://article.gmane.org/gmane.linux.kernel.wireless.general/61860

> I don't think so -- I don't recall anyone ever asking before ;-)

I definetly want this functionality for my WLAN monitoring tool ("horst" - 
http://br1.einfach.org/horst). A similar patch has also been discussed for 
aircrack-ng in June 2010 (https://patchwork.kernel.org/patch/103589/).

I understand your point of not wanting to report wrong information, esp when 
we have multiple interfaces on different channels - but in most situations for 
sniffers etc this is not the case, we just have one monitor interface or one 
interface + one monitor interface, in which cases I believe we should be able 
to report a channel.

So just for the record: I want it, pretty please! :)

bruno
