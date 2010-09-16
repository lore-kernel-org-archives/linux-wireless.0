Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47420 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab0IPTol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 15:44:41 -0400
Date: Thu, 16 Sep 2010 15:36:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	br1@einfach.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: reorder base.c to remove fwd decls
Message-ID: <20100916193652.GE7221@tuxdriver.com>
References: <1284231996-29010-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1284231996-29010-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 11, 2010 at 03:06:36PM -0400, Bob Copeland wrote:
> This change reorganizes the main ath5k file in order to re-group
> related functions and remove most of the forward declarations
> (from 61 down to 3).  This is, unfortunately, a lot of churn, but
> there should be no functional changes.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> 
> Worth the churn?  Is there any way to do this kind of patch that
> doesn't suck?

Apparently not...

Well, I hate to ask for a rebase -- but this doesn't apply anymore!
I would just fix it up, but that offending hunk is 2500 lines or so...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
