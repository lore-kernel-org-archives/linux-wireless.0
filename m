Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:51769 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753467AbXFTJ4A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 05:56:00 -0400
Date: Wed, 20 Jun 2007 11:55:59 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Hong Liu <hong.liu@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [patch]mac80211: add support for iwlist channel
Message-ID: <20070620115559.301e10eb@griffin.suse.cz>
In-Reply-To: <1182305425.19178.12.camel@napa-sdv1.sh.intel.com>
References: <1182156425.15928.7.camel@napa-sdv1.sh.intel.com>
	<20070619105024.3c6c68e3@griffin.suse.cz>
	<1182305425.19178.12.camel@napa-sdv1.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 20 Jun 2007 10:10:25 +0800, Hong Liu wrote:
> What is the meaning of IEEE80211_CHAN_W_SCAN flag? I can't find any
> description of this flag.

It means we can tune to that channel. That way you can have all
channels the hardware support in the channel list in ieee80211_hw_mode
struct and mask out channels disallowed by the regulations.

Yes, it's misnamed. Worse, all of these IEEE80211_CHAN_W_ flags are not
documented. Patches are welcome.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
