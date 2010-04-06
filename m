Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44168 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab0DFVaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 17:30:11 -0400
Date: Tue, 6 Apr 2010 17:18:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] rt2x00: Powersave fixes.
Message-ID: <20100406211836.GE3017@tuxdriver.com>
References: <1269985826-17438-1-git-send-email-gwingerde@gmail.com> <20100406193409.GA3017@tuxdriver.com> <4BBB90F6.8060406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4BBB90F6.8060406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 06, 2010 at 09:52:22PM +0200, Gertjan van Wingerde wrote:
> On 04/06/10 21:34, John W. Linville wrote:

> > Any objection to me applying them for 2.6.35?
> > 
> 
> You're the boss ;-)

More like "coordinator" I think... :-)

> No, no objections from my side. We already disabled powersaving in 2.6.34,
> so we should be covered for that release.
> 
> Note that patch 2 then won't apply to wireless-next-2.6, as the patch
> that disables powersaving is only in wireless-2.6.
> 
> How do you want to handle applying patch 2 from the series; how do we
> synchronize?

I'm hitting this type of problem with a number of pending patches now.
I'll need to pull wireless-2.6 into wireless-next-2.6 soon.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
