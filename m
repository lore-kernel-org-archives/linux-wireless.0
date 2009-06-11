Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49114 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758030AbZFKKBL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 06:01:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 03:01:14 -0700
Date: Thu, 11 Jun 2009 15:29:50 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <mcgrof@gmail.com>
Subject: Re: [RFT 2/3] ath9k: port to cfg80211 rfkill
Message-ID: <20090611095949.GD10126@vasanth-laptop>
References: <20090602111027.460530075@sipsolutions.net> <20090602111112.191915040@sipsolutions.net> <20090610132015.GA10126@vasanth-laptop> <1244644712.26814.6.camel@johannes.local> <20090611065203.GC10126@vasanth-laptop> <1244714262.4706.7.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1244714262.4706.7.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2009 at 03:27:41PM +0530, Johannes Berg wrote:
> 
> Well, the thing is that currently ath_start_rfkill_poll() will never be
> called until you try bringing the interface up, afaict?

right.

Vasanth
