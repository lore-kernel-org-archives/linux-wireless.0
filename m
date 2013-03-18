Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36572 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3CRUDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 16:03:11 -0400
Message-ID: <1363636984.8260.17.camel@jlt4.sipsolutions.net> (sfid-20130318_210314_702727_3A47D26C)
Subject: Re: BUG: problem while tracing cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, David Spinadel <dvdspndl@gmail.com>
Date: Mon, 18 Mar 2013 21:03:04 +0100
In-Reply-To: <51476F35.9040909@broadcom.com>
References: <51476F35.9040909@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-18 at 20:47 +0100, Arend van Spriel wrote:
> Hi Johannes,
> 
> While testing David Spinadel's P2P device support functionality I got 
> the following blurb, which is probably caused by cfg80211 tracing given 
> the instruction pointer address.
> 
> brcmfmac returns ERR_PTR(-ENOENT) and I think the trace code/macros do 
> not take this into account.

I guess this should fix it?

http://p.sipsolutions.net/fdea39f2a56aff67.txt

johannes

