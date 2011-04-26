Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48220 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab1DZTPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 15:15:46 -0400
Date: Tue, 26 Apr 2011 15:08:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.39 v2] iwlegacy: led stay solid on when no traffic
Message-ID: <20110426190816.GH2804@tuxdriver.com> (sfid-20110426_211553_196183_AB3C33EF)
References: <1303755177-28781-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303755177-28781-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 25, 2011 at 11:12:57AM -0700, Wey-Yi Guy wrote:
> commit 843f26f06a41c5797f19e843c23ca4ed2a71a0bc change the led behavior
> for iwlwifi driver; the side effect cause led blink all the time.
> 
> Modify the led blink table to fix this problem
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Patch seems fine, but I can't find the listed commit ID that caused this issue?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
