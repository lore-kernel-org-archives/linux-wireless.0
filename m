Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:23026 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbXJRTLI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 15:11:08 -0400
Date: Thu, 18 Oct 2007 21:11:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Rate problems with iwl3945
Message-ID: <20071018191102.GI10674@kernel.dk> (sfid-20071018_201111_899199_F92BB71F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I wrote yesterday about my peering issues with this driver. After
getting the hint that iwlist scan would make it associate, I got that
working.

Copying some files I noticed it was slow, though. iwconfig reveals that
it's only running at 5.5Mb/s and indeed I only get around 650-700kb/sec
copying data. I tried to force it to 54M, but no matter what setting I
try with iwconfig rate, it stays at 5.5 and the performance stinks. With
ipw3945 I always got around ~3mb/s scp'ing data.

With the risk of sounding rude, is this driver expected to be of
production quality? It doesn't link, performance is bad. Am I better off
sticking to ipw3945 still? Are there patches out there I can try? Who
maintains this driver?

-- 
Jens Axboe

