Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34918 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab2KZQBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:01:31 -0500
Date: Mon, 26 Nov 2012 10:54:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac tx patches for 3.7
Message-ID: <20121126155455.GB27232@tuxdriver.com> (sfid-20121126_170135_306266_43668E1E)
References: <50AE8BD3.8040902@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50AE8BD3.8040902@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 22, 2012 at 09:32:19PM +0100, Arend van Spriel wrote:

> When Seth posted his rework on brcmsmac transmit, we had a number of
> patches ready in the same area albeit less rigorous. With Seth's patches
> lined up in wireless-next for 3.8, I am wondering what to do here.
> Should I send our patches against the wireless tree? These patches will
> definitely result in conflicts when merging to wireless-next, which you
> typically do. Actually, we do not want these patches in wireless-next as
> rework from Seth makes them irrelevant.
> 
> Any advice on this?

If they are fixes, then they should be small and obvious -- hopefully
that makes the merging relatively easy?  You might try applying
them to a local wireless tree and pulling that into a local copy of
wireless-next, then resolving the conflicts locally so that you can
give me some idea of any tricky merges?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
