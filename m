Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab2GENTT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 09:19:19 -0400
Message-ID: <1341494355.4455.43.camel@jlt3.sipsolutions.net> (sfid-20120705_151922_857422_54A4BD90)
Subject: Re: [PATCH v2 0/2] High bitrate support
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 05 Jul 2012 15:19:15 +0200
In-Reply-To: <1341487550-11502-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341487550-11502-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-05 at 14:25 +0300, Vladimir Kondratiev wrote:
> I like what Johannes suggested, thus name for new bitrate option
> changed to NL80211_RATE_INFO_BITRATE32
> 
> Patch for iw will follow shortly
> 
> Proposed patches solve issue with high bitrates not fitting into u16.                                                                                                              
>                                                                                                                                                                                    
> I split it into 2 patches: one introduces new u32 bitrate,                                                                                                                         
> and 2-nd adds 60g specific calculations.                                                                                                                                           
>                                                                                                                                                                                    
> Idea is to report (in nl80211) both old and new values,
> or only new if it not fits into u16.
> User space tools encouraged to migrate to the new bitrate.

Applied, thanks. I've done a few small modifications in comments since
we can't just have userspace migrate, it needs to be compatible with
older kernels.

I'll apply the iw patches after I push this to John.

johannes

