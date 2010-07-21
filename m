Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab0GUHx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 03:53:27 -0400
Subject: Re: [PATCH/RFC 3/3] ath5k: trace resets
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <201007211417.23512.br1@einfach.org>
References: <1279395336-856-1-git-send-email-me@bobcopeland.com>
	 <201007211004.59372.br1@einfach.org> <20100721034150.GA16632@hash.localnet>
	 <201007211417.23512.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 09:53:21 +0200
Message-ID: <1279698801.3707.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-21 at 14:17 +0900, Bruno Randolf wrote:

> but that's for all tracepoints all over the kernel...

Well you definitely don't want to enable like function graph tracing,
that's expected to be more expensive unless you also have the callsite
patching version of it. But _just_ enabling tracing + the ath5k tracer
definitely will not have this effect.

johannes

