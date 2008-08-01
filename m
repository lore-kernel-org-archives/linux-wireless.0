Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4163 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbYHASDz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 14:03:55 -0400
Date: Fri, 1 Aug 2008 13:30:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] mac80211: add direct probe before association
Message-ID: <20080801173044.GB14974@tuxdriver.com> (sfid-20080801_200359_110767_C47D040F)
References: <1216076865-9826-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1216076865-9826-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 15, 2008 at 02:07:45AM +0300, Tomas Winkler wrote:
> This patch adds a direct probe request as first step in the association
> flow. Motivation of this step is to make sure that the bss information
> we have is up to date, since last scan could have been done a while ago.
> beacons do not fully answer this need as there are potential differences
> between them and probe responses (e.g. WMM parameter element)
> 
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Does this fix a bug?  Seems likely...

John
-- 
John W. Linville
linville@tuxdriver.com
