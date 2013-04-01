Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sapphire.tuxdriver.com ([70.61.120.61]:33318 "EHLO
	Linville-X1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757487Ab3DARoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 13:44:13 -0400
Date: Mon, 1 Apr 2013 13:43:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Robert Shade <robert.shade@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Re-enable interrupts after a channel change
 failure
Message-ID: <20130401174343.GE21859@tuxdriver.com> (sfid-20130401_194416_895153_C4CBFDC8)
References: <CAMgrJ3b0EUUae8k1Z2RR92eLbFyPGpqA5px1J_gALDTJ+rmAnA@mail.gmail.com>
 <CAJ-Vmo=TBiJjs-DF-BfV95Mz8-Ro_aDa-dxcSOVC20rk9T5bqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmo=TBiJjs-DF-BfV95Mz8-Ro_aDa-dxcSOVC20rk9T5bqA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 01, 2013 at 09:25:43AM -0700, Adrian Chadd wrote:
> You filed a bug against this, right? Can you mention the bug report in there?
> 
> (What's the "blessed" way to mention a bugzilla.kernel.org bug in a
> linux git commit?)

I usually just include the URL.  "Fixes Bug #12345" would suffice as well.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
