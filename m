Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43104 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab2EJQ4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 12:56:40 -0400
Message-ID: <1336668998.4334.24.camel@jlt3.sipsolutions.net> (sfid-20120510_185644_587851_0134064A)
Subject: Re: [PATCH 1/4] iwlwifi: Add __printf argument checking to __iwl_dbg
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 10 May 2012 18:56:38 +0200
In-Reply-To: <1336668634.4334.23.camel@jlt3.sipsolutions.net> (sfid-20120510_185043_029152_81B6AB28)
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
	 <1336665952-24363-2-git-send-email-johannes@sipsolutions.net>
	 <1336667905.22495.18.camel@joe2Laptop>
	 <1336668634.4334.23.camel@jlt3.sipsolutions.net>
	 (sfid-20120510_185043_029152_81B6AB28)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-10 at 18:50 +0200, Johannes Berg wrote:
> On Thu, 2012-05-10 at 09:38 -0700, Joe Perches wrote:
> > Add gcc format and argument printf checking
> > to reduce future defect introduction.
> 
> Good point, I'll pick this up.

I'll also add it to the other functions __iwl_crit etc.

Thanks for the suggestion!

johannes

