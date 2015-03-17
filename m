Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53185 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbbCQKDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 06:03:16 -0400
Message-ID: <1426586592.1985.4.camel@sipsolutions.net> (sfid-20150317_110326_979554_386822A1)
Subject: Re: [PATCH] cfg80211: Process all pending regulatory requests/hints
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@suse.org,
	Ben <ben.rosenfeld@intel.com>
Date: Tue, 17 Mar 2015 11:03:12 +0100
In-Reply-To: <1426167454-7070-1-git-send-email-ilan.peer@intel.com> (sfid-20150312_203539_613472_27D4FE32)
References: <1426167454-7070-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20150312_203539_613472_27D4FE32)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-03-12 at 09:37 -0400, Ilan Peer wrote:
> From: Ben <ben.rosenfeld@intel.com>
> 
> It is possible that there are several regulatory requests
> pending, but the processing of the last one does not call
> CRDA, and thus the other requests are not handled.
> 
> Fix this by rescheduling the work until all requests have been
> processed.

Applied.

johannes

