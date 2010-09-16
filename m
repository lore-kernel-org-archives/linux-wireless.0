Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2319 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab0IPXVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 19:21:51 -0400
Date: Thu, 16 Sep 2010 19:18:46 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	br1@einfach.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: reorder base.c to remove fwd decls
Message-ID: <20100916231846.GA28873@hash.localnet>
References: <1284231996-29010-1-git-send-email-me@bobcopeland.com> <20100916193652.GE7221@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100916193652.GE7221@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 03:36:52PM -0400, John W. Linville wrote:
> > Worth the churn?  Is there any way to do this kind of patch that
> > doesn't suck?
> 
> Apparently not...
> 
> Well, I hate to ask for a rebase -- but this doesn't apply anymore!
> I would just fix it up, but that offending hunk is 2500 lines or so...

(for Bruno's benefit since I said as much on irc) -- I'll redo this
one as soon as the crypto series is pushed out in w-t.

-- 
Bob Copeland %% www.bobcopeland.com

