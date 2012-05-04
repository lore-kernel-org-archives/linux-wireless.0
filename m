Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60670 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2EDEmH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 00:42:07 -0400
Subject: Re: linux-next: manual merge of the net-next tree with the
 wireless tree
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	alexander.duyck@gmail.com, alexander.h.duyck@intel.com,
	jeffrey.t.kirsher@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <20120504132138.d0142070434e502dfcb8a980@canb.auug.org.au>
References: <20120504132138.d0142070434e502dfcb8a980@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 May 2012 21:35:30 -0700
Message-ID: <1336106130.11261.5.camel@wwguy-huron> (sfid-20120504_064226_815153_95D26FE1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-04 at 13:21 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got conflicts in
> drivers/net/wireless/iwlwifi/iwl-trans.h,
> drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c, and
> drivers/net/wireless/iwlwifi/iwl-agn-rx.c between commit ed90542b0ce5
> ("iwlwifi: fix skb truesize underestimation") from the wireless tree and
> various commits from the net-next tree.
> 
> This was anticipated and I have applied the fix supplied by John (see
> below just to check).  Thanks to John for this!

Thanks everyone to help address this, it is my miss to cause all these trouble

Wey


