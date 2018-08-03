Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728450AbeHCMFS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 08:05:18 -0400
Date: Fri, 3 Aug 2018 12:09:40 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Wireless <linux-wireless@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mt76x0: build driver only as module
Message-ID: <20180803100939.GE10284@redhat.com> (sfid-20180803_120953_812315_E1B6E467)
References: <20180803091401.GB10284@redhat.com>
 <87zhy36c4n.fsf@kamboji.qca.qualcomm.com>
 <20180803092822.GD10284@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180803092822.GD10284@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 03, 2018 at 11:28:22AM +0200, Stanislaw Gruszka wrote:
> > But this feels like an ugly hack to me. Isn't there a better way to fix
> > this? (I don't have time to investigate the error in detail right now.)
> 
> Yes, rename symbols names. And I will do this, just wanted to provide
> quick fix for the problem. 
> 
> Moreover seems the same thing should be done for mt7601u to avoid build
> errors and perhaps with mt76 :-( 
> 
> So I'm going to rename functions.

I have the patches, I'm building kernel with allyesconfig now,
it will take a while ...

Stanislaw
