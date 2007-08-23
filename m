Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3244 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761530AbXHWVPU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 17:15:20 -0400
Date: Thu, 23 Aug 2007 16:54:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/27] various cleanups and fixes for mac80211 and  drivers
Message-ID: <20070823205411.GH2989@tuxdriver.com>
References: <20070821145905.689978000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070821145905.689978000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 21, 2007 at 04:59:05PM +0200, Johannes Berg wrote:
> I've stripped my patch series down to those things that
> nobody objected to. The ioctl removal is a bit slimmer
> keeping the things Jouni wanted to keep.
> 
> This series contains:
> 
>  * mac80211: fix showing transmitted frames on multiple monitor interfaces
>  * mac80211: fix preamble setting
>  * mac80211: avoid copying packets to interfaces that are down
>  * mac80211: fix key debugfs
>  * mac80211, drivers: remove reset callback
>  * ralink drivers: remove IEEE80211_HW_HOST_GEN_BEACON flag
>  * mac80211: remove IEEE80211_HW_HOST_GEN_BEACON flag
>  * mac80211: remove PRISM2_PARAM_RADIO_ENABLED
>  * mac80211: remove PRISM2_HOSTAPD_SET_GENERIC_INFO_ELEM
>  * ralink drivers: remove IEEE80211_HW_DATA_NULLFUNC_ACK
>  * rtl8187: remove IEEE80211_HW_DATA_NULLFUNC_ACK
>  * p54: remove IEEE80211_HW_DATA_NULLFUNC_ACK
>  * mac80211: remove IEEE80211_HW_DATA_NULLFUNC_ACK
>  * mac80211: ratelimit some RX messages
>  * mac80211: remove ieee80211_msg_wep_frame_unknown_key
>  * mac80211: remove radar stuff
>  * mac80211: remove scan struct from hostapd_param
>  * mac80211: fix software decryption
>  * cfg80211: extend radiotap parser by all remaining fields
>  * mac80211: remove unused ioctls (1)
>  * mac80211: remove unused ioctls (2)
>  * mac80211: remove unused ioctls (3)
>  * mac80211: remove unused ioctls (4)
>  * mac80211: remove PRISM2_PARAM_KEY_MGMT
>  * mac80211: kill key_mgmt, use key_management_enabled
>  * mac80211: refactor event sending
>  * mac80211: use switch statement in tx code

I've merged the lot to the 'mac80211' branch (and driver patches to
their respective branches) of wireless-dev, and it is available on
'everything' as well.

Johannes, I appreciate your continued dedication to the cause! :-)

John
-- 
John W. Linville
linville@tuxdriver.com
