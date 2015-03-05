Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbbCEWz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 17:55:27 -0500
Date: Thu, 5 Mar 2015 23:55:26 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v10 3/3] cfg80211: Schedule timeout for all CRDA calls
Message-ID: <20150305225526.GC25035@wotan.suse.de> (sfid-20150305_235530_475137_C30BAA08)
References: <1425447127-22958-1-git-send-email-ilan.peer@intel.com>
 <1425447127-22958-3-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425447127-22958-3-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 04, 2015 at 12:32:07AM -0500, Ilan Peer wrote:
> Timeout was scheduled only in case CRDA was called due to user hints,
> but was not scheduled for other cases. This can result in regulatory
> hint processing getting stuck in case that there is no CRDA configured.
> 
> Change this by scheduling a timeout every time CRDA is called. In
> addition, in restore_regulatory_settings() all pending requests are
> restored (and not only the user ones).
> 
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@suse.com>

For all of these.

 Luis
