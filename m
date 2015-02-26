Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbbBZCKa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 21:10:30 -0500
Date: Thu, 26 Feb 2015 03:10:29 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7 1/3] cfg80211: Simplify the handling of regulatory
	indoor setting
Message-ID: <20150226021029.GG8749@wotan.suse.de> (sfid-20150226_031036_868554_863B5A37)
References: <1424857624-24944-1-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424857624-24944-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2015 at 04:47:02AM -0500, Ilan Peer wrote:
> Directly update the indoor setting without wrapping it as
> a regulatory request, to simplify the processing.
> 
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@suse.com>

  Luis
