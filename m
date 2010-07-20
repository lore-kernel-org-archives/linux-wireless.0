Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab0GTHya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 03:54:30 -0400
Subject: Re: [ath5k-devel] [PATCH/RFC 0/3] ath5k: add driver tracepoints
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201007201411.51259.br1@einfach.org>
References: <1279395336-856-1-git-send-email-me@bobcopeland.com>
	 <201007201411.51259.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 09:54:19 +0200
Message-ID: <1279612459.3706.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-07-20 at 14:11 +0900, Bruno Randolf wrote:

> hmm, this is really nice stuff, but i'm not sure what to do on embedded boards 
> where we don't have python or where it's not possible to use tracing in 
> general due to (low) performance reasons

err, tracing has much better performance than printk, and you can get
the trace into a file that you can analyse offline on a "real" machine.
No need for python on the board, and tracing improves performance over
printk.

johannes

