Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16425 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZDTBRG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 21:17:06 -0400
Subject: Re: [PATCH] MAC80211: Remove unused
 MAC80211_VERBOSE_SPECT_MGMT_DEBUG.
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1240061918.4755.42.camel@johannes.local>
References: <alpine.LFD.2.00.0904180930530.3509@localhost.localdomain>
	 <1240061918.4755.42.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 09:11:13 +0800
Message-Id: <1240189873.354.38.camel@debian> (sfid-20090420_031713_861870_7C66A1D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-04-18 at 21:38 +0800, Johannes Berg wrote:
> On Sat, 2009-04-18 at 09:33 -0400, Robert P. J. Day wrote:
> > Remove this unused Kconfig variable, which Intel apparently once
> > promised to make use of but never did.
> > 
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Ack. Sorry about it!

Thanks,
-yi

> FWIW, this is the exact revert of the commit introducing the option:
> 
> commit 7b1e78d5052a92e95d851fbb0236a712264fe7e8
> Author: Yi Zhu <yi.zhu@intel.com>
> Date:   Wed Jun 18 17:53:43 2008 +0300
> 
>     mac80211: add MAC80211_VERBOSE_SPECT_MGMT_DEBUG Kconfig option
>     
>     The patch introduces MAC80211_VERBOSE_SPECT_MGMT_DEBUG Kconfig option to
>     suppress Spectrum Management 802.11h related debug logs.
>     
>     Signed-off-by: Zhu Yi <yi.zhu@intel.com>
>     Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> 
> So it's been there for over half a year. I guess we learn from that to
> not take Kconfig symbols that are unused in the first place ;)
> 
> johannes

