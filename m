Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:10671 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab2HAWJj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 18:09:39 -0400
Date: Wed, 1 Aug 2012 18:09:34 -0400
From: Pavel Roskin <proski@gnu.org>
To: Mijzelf <Mijzelf@live.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Uknown symbols in rfkill_backport.ko on 2.6.25.17 on mips
Message-ID: <20120801180934.4dc2c9e3@mj> (sfid-20120802_000942_537504_AE8267C1)
In-Reply-To: <loom.20120729T135851-141@post.gmane.org>
References: <0621389a37a568a7ebd526b0adc87a48@fileserver.lan>
	<20120724175617.0a4206c4@mj>
	<loom.20120725T195215-756@post.gmane.org>
	<20120726172555.246a668c@mj>
	<loom.20120729T135851-141@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 29 Jul 2012 12:31:16 +0000 (UTC)
Mijzelf <Mijzelf@live.com> wrote:

> Looking at this it seems to me it must be some compiler-inserted
> memory barrier, or something like that. But that memcpy baffles me.

You did a great job tracking down the problem.  I think the next step
would be to ask in the mips mailing list.  The wireless subsystem has
nothing to do with that problem.

> I think I'll just add a dummy _flush_cache. My target system is
> single core, I suppose it would be safe.

I think it's worth trying.

-- 
Regards,
Pavel Roskin
