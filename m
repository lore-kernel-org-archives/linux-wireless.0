Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3942 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbYFOBDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2008 21:03:16 -0400
Date: Sat, 14 Jun 2008 20:40:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH stable] b43: Fix noise calculation WARN_ON
Message-ID: <20080615004056.GB1396@tuxdriver.com> (sfid-20080615_030320_259047_18877A57)
References: <200806142300.15391.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200806142300.15391.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 14, 2008 at 11:00:14PM +0200, Michael Buesch wrote:
> This removes a WARN_ON that is responsible for the following koops:
> http://www.kerneloops.org/searchweek.php?search=b43_generate_noise_sample
> 
> The comment in the patch describes why it's safe to simply remove
> the check.
> 
> This patch is upstream in John Linville's wireless-testing.git tree
> as commit 86ef1ae07289c9f0aa1aa310d43653e513e6f124

...and will probably be 98a3b2fe435ae76170936c14f5c9e6a87548e3ef
in linux-2.6.git.

John
-- 
John W. Linville
linville@tuxdriver.com
