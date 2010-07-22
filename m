Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:27189 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751926Ab0GVJSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 05:18:47 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-014788324
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 18:18:45 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFC 3/3] ath5k: trace resets
Date: Thu, 22 Jul 2010 18:21:26 +0900
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, Ben Gamari <bgamari@gmail.com>
References: <1279395336-856-1-git-send-email-me@bobcopeland.com> <201007211417.23512.br1@einfach.org> <1279698801.3707.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1279698801.3707.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201007221821.26129.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed July 21 2010 16:53:21 Johannes Berg wrote:
> On Wed, 2010-07-21 at 14:17 +0900, Bruno Randolf wrote:
> > but that's for all tracepoints all over the kernel...
> 
> Well you definitely don't want to enable like function graph tracing,
> that's expected to be more expensive unless you also have the callsite
> patching version of it. But _just_ enabling tracing + the ath5k tracer
> definitely will not have this effect.

true. i just checked it again and enabling tracing does not affect the 
performance as i have wrongly stated before. i must have had some other 
debugging stuff enabled as well. sorry...

bruno
