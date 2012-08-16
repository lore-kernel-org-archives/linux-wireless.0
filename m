Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875Ab2HPKWb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 06:22:31 -0400
Date: Thu, 16 Aug 2012 12:22:11 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
Message-ID: <20120816102211.GD17659@redhat.com> (sfid-20120816_122332_281899_9D86993B)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCDD559@mbx022-e1-nj-10.exch022.domain.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCDD559@mbx022-e1-nj-10.exch022.domain.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2012 at 03:55:26PM +0000, Mahesh Palivela wrote:
> Handling of 80 MHz, 160 MHz channel bandwidths for VHT (11ac) Regulatory
> and setting channel flags for allowed bandwidths.
> 
> Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
> ---
> 
> Sending patch second time as Stanislaw Gruszka complained its malformed.

And now complaining that patch is ugly. There is really on other,
simpler way to handle that?

Stanislaw
