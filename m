Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab2HNMFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 08:05:53 -0400
Date: Tue, 14 Aug 2012 14:05:22 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
Message-ID: <20120814120521.GE2423@redhat.com> (sfid-20120814_140556_759404_BEB64131)
References: <5029FEF3.3010707@posedge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5029FEF3.3010707@posedge.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2012 at 01:02:03PM +0530, Mahesh Palivela wrote:
> Handling of 80 MHz, 160 MHz channel bandwidths for VHT (11ac)
> Regulatory and setting channel flags for allowed bandwidths.
> 
> Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
> ---
> 
>  include/net/cfg80211.h |   64 +++++++++++++++--
>  net/wireless/reg.c     |  183
> +++++++++++++++++++++++++++++++++++++++++++++++-
>  net/wireless/reg.h     |    5 ++
Patch was malformed by your email client or similar.

Stanislaw
