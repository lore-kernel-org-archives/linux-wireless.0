Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B85BC0015E
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jul 2023 16:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbjGLQqM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Jul 2023 12:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbjGLQqK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2023 12:46:10 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A4D10C7;
        Wed, 12 Jul 2023 09:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689180369; x=1720716369;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rXDvBkAUPlbp09GLN3GKPktPhdzuNV5ghtq1N7pdjtA=;
  b=gvXdGxrL6xwNkTvcrgkf66+4O/6qmVQB2kDjtKzmuZ3AOWRfY36ce4S9
   m0oLe2NcS1Mhp/dpfyQW8zddUc3gvAy/8tbpUxfoG1kvfhI/fcsd+xPiu
   kfpl5rg7sqRA7dD0kw2ynDpbaoyi37VWHBXZLHxQgLGbs5MlDNoJnM52L
   onKjTcAIP037OF4f5XhCX5/M9E/HbmpP2NYWtQeRZCgTrBtv20vXdv5Cl
   jgdvLaO556vYQaQ/x1956c/SAlcpLTbeapehpaXbLtWeMvc79WWsrJkrJ
   Q7xnkWU8djSBI+3NinaCt+SPaAez4TRw9yq9WbhUSQpWkDLiY7lRDsPhH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="367563970"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="367563970"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 09:46:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="698923679"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="698923679"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006.jf.intel.com with ESMTP; 12 Jul 2023 09:46:06 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@intel.com>)
        id 1qJcyb-002BXr-0z;
        Wed, 12 Jul 2023 19:46:05 +0300
Date:   Wed, 12 Jul 2023 19:46:05 +0300
From:   Andy Shevchenko <andriy.shevchenko@intel.com>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Closing down the wireless trees for a summer break?
Message-ID: <ZK7Yzd0VvblA3ONU@smile.fi.intel.com>
References: <87y1kncuh4.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y1kncuh4.fsf@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jun 13, 2023 at 05:22:47PM +0300, Kalle Valo wrote:

...

> [1] https://phb-crystal-ball.sipsolutions.net/

How could one use the shut down site?

Also see
https://www.reddit.com/r/linux/comments/s09as7/looks_like_the_domain_registration_recently/
http://deb.tandrin.de/phb-crystal-ball.htm



-- 
With Best Regards,
Andy Shevchenko


