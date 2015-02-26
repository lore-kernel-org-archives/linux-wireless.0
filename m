Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbbBZCSN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 21:18:13 -0500
Date: Thu, 26 Feb 2015 03:18:11 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7 3/3] cfg80211: Schedule timeout for all CRDA calls
Message-ID: <20150226021811.GI8749@wotan.suse.de> (sfid-20150226_031816_239187_0CE5B125)
References: <1424857624-24944-1-git-send-email-ilan.peer@intel.com> <1424857624-24944-3-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424857624-24944-3-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2015 at 04:47:04AM -0500, Ilan Peer wrote:
> Timeout was scheduled only in case CRDA was called due to user hints,
> but was not scheduled for other cases. This can result in regulatory
> hint processing getting stuck in case that there is no CRDA configured.
> 
> Change this by scheduling a timeout every time CRDA is called. In
> addition, in restore_regulatory_settings() all pending requests are
> restored (and not only the user ones).
> 
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>

I think I had acked this already. If so add the tag.

  Luis
