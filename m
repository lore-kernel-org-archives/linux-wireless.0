Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40382 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZAWTpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:45:45 -0500
Date: Fri, 23 Jan 2009 14:40:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/7] airo: cleanups and simplifications
Message-ID: <20090123194010.GD30486@tuxdriver.com> (sfid-20090123_204551_413581_A5ABE0B3)
References: <1232462691.22158.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1232462691.22158.6.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 09:44:51AM -0500, Dan Williams wrote:
> airo needs some hot sexy love.  come and get your love come and get your
> love now.
> 
> [PATCH 1/7] airo: clean up and clarify interrupt-time task handling
> [PATCH 2/7] airo: re-arrange WPA capability checks
> [PATCH 3/7] airo: simplify WEP index and capability checks
> [PATCH 4/7] airo: clean up WEP key operations
> [PATCH 5/7] airo: use __attribute__ ((packed)) not #pragma
> [PATCH 6/7] airo: clean up and clarify micinit()
> [PATCH 7/7] airo: remove useless #defines

1-4 (v2 of #4) don't seem to apply to wireless-testing anymore.  #1 in
particular was a big reject, so I didn't try too hard on the rest.
I'll drop 5-7 too just in case there are dependencies.

Would you mind rebasing and reposting?

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
