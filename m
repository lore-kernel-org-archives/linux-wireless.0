Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:45600 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933427Ab0GUFPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 01:15:01 -0400
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-074339296
	for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 14:14:57 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH/RFC 3/3] ath5k: trace resets
Date: Wed, 21 Jul 2010 14:17:23 +0900
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	johannes@sipsolutions.net
References: <1279395336-856-1-git-send-email-me@bobcopeland.com> <201007211004.59372.br1@einfach.org> <20100721034150.GA16632@hash.localnet>
In-Reply-To: <20100721034150.GA16632@hash.localnet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007211417.23512.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed July 21 2010 12:41:50 Bob Copeland wrote:
> On Wed, Jul 21, 2010 at 10:04:59AM +0900, Bruno Randolf wrote:
> > the difference. without tracing you can get 22Mbps, with tracing max
> > 15Mbps UDP thruput.
> 
> If so, and it's not an i-cache effect, then something is wrong with
> the tracing subsystem.  It's supposed to compile to something like
> 
> if (tracing) {
>    trace_callback();
> }
> 
> That is exactly what we have with the debug infrastructure, but
> the debug stuff is theoretically a bit worse since it tests for
> tracing inside the callback.

but that's for all tracepoints all over the kernel... i think it's natural 
that this takes some CPU time. note that on these boards even the 22Mbps are 
limited by the CPU processing power.

> Oh well, I guess I need to get my hands on one of these boards.

could be helpful, allthough i have to admit that these boards are getting old 
and more current embedded boards usually do have faster CPUs...

bruno
