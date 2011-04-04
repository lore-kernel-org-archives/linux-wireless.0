Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:46779 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1DDUSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 16:18:21 -0400
Date: Mon, 4 Apr 2011 20:47:16 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jens Axboe <jaxboe@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 2.6.39-rc1 from commit
	7eaceaccab5f40bbfda044629a6298616aeaed50
Message-ID: <20110404194716.GB8785@sucs.org>
References: <4D9A0D97.1060505@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D9A0D97.1060505@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 04, 2011 at 01:27:35PM -0500, Larry Finger wrote:
> After I pulled 2.6.39-rc1, my HP laptop failed to boot by never advancing 
> past the device detection stage on my x86_64 system. The problem was 
> bisected, which led to:

Sounds like the same as http://marc.info/?t=130137969500005&r=1&w=2
("Commit 7eaceaccab5f40 causing boot hang.") ...

-- 
Sitsofe | http://sucs.org/~sits/
