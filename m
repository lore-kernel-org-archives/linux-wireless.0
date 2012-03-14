Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab2CNHH5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 03:07:57 -0400
Date: Wed, 14 Mar 2012 08:07:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: do not nulify ctx->vif on reset
Message-ID: <20120314070748.GB2788@redhat.com> (sfid-20120314_080800_623731_9D6A0086)
References: <1331651434-4370-1-git-send-email-sgruszka@redhat.com>
 <1331651730.3329.6.camel@jlt3.sipsolutions.net>
 <20120314062549.GA2788@redhat.com>
 <1331708304.3376.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331708304.3376.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 14, 2012 at 07:58:24AM +0100, Johannes Berg wrote:
> But last I tried (after refactoring queue stop/wake), I could
> successfully recover from hw restart in the middle of aggregation
> sessions -- which code did you try with?

commit 2c32d37f937092466d7f32e369854581caebe03d
Merge: 8da63e5 1745e44
Author: John W. Linville <linville@tuxdriver.com>
Date:   Fri Mar 9 14:41:43 2012 -0500

    Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next

I'll update and recheck again.

Stanislaw
