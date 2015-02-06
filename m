Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbbBFX7w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 18:59:52 -0500
Date: Sat, 7 Feb 2015 00:59:50 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 2/2] cfg80211: Schedule timeout for all CRDA calls
Message-ID: <20150206235950.GB19988@wotan.suse.de> (sfid-20150207_005955_897330_789100A7)
References: <1422889166-29386-1-git-send-email-ilan.peer@intel.com> <1422889166-29386-2-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422889166-29386-2-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 02, 2015 at 09:59:26AM -0500, Ilan Peer wrote:
> Timeout was scheduled only in case CRDA was called due to user hints,
> but was not scheduled for other cases. This can result in regulatory
> hint processing getting stuck in case that there is no CRDA configured.
> 
> Change this by scheduling a timeout every time CRDA is called. In
> addition, in restore_regulatory_settings() all pending requests are
> restored (and not only the user ones).
> 
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@suse.com>

  Luis
