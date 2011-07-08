Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1GHQd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:33:26 -0400
Date: Fri, 8 Jul 2011 18:33:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-mtd@lists.infradead.org
Subject: Re: [RFC 6/9]drivers:char:nvram.c Change the copyright info.
In-Reply-To: <1290838879-11038-7-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1107081832490.11049@pobox.suse.cz> (sfid-20110708_183346_675795_0F1B7ABB)
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com> <1290838879-11038-7-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 26 Nov 2010, Justin P. Mattock wrote:

> Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/char/nvram.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
> index 166f1e7..33e8faa 100644
> --- a/drivers/char/nvram.c
> +++ b/drivers/char/nvram.c
> @@ -3,7 +3,7 @@
>   *
>   * Copyright (C) 1997 Roman Hodek <Roman.Hodek@informatik.uni-erlangen.de>
>   * idea by and with help from Richard Jelinek <rj@suse.de>
> - * Portions copyright (c) 2001,2002 Sun Microsystems (thockin@sun.com)
> + * Portions copyright (c) 2001,2002 Oracle and/or its affiliates. (thockin@sun.com)
>   *
>   * This driver allows you to access the contents of the non-volatile memory in
>   * the mc146818rtc.h real-time clock. This chip is built into all PCs and into

You can't just change other people/company copyright.

This will need Signoff from the original copyright holder at least.

-- 
Jiri Kosina
SUSE Labs
