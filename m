Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:63103 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbZBOQmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 11:42:49 -0500
Received: by ey-out-2122.google.com with SMTP id 25so255635eya.37
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 08:42:46 -0800 (PST)
Message-ID: <499845E0.3020004@gmail.com> (sfid-20090215_174252_806609_92285DE8)
Date: Sun, 15 Feb 2009 16:42:08 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [Orinoco-devel] [PATCH] orinoco: do not resgister NULL pm_notifier
 function
References: <20090215094753.31795.19546.stgit@cooker.net>
In-Reply-To: <20090215094753.31795.19546.stgit@cooker.net>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> With DEBUG_NOTIFIERS it results in
> 
> [11330.890966] WARNING: at /home/bor/src/linux-git/kernel/notifier.c:88
> notifier_call_chain+0x91/0xa0()
> [11330.890977] Hardware name: PORTEGE 4000
> [11330.890983] Invalid notifier called! ...
> 
> Without DEBUG_NOTIFIERS it most likely crashes on NULL pointer.
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

Acked-by: David Kilroy <kilroyd@googlemail.com>

Thanks for finding and fixing up the bugs I keep injecting :)
