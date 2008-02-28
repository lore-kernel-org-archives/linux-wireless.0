Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3614 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbYB1Ode (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 09:33:34 -0500
Date: Thu, 28 Feb 2008 09:06:05 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: hostapd with mac80211 progress
Message-ID: <20080228140605.GB3063@tuxdriver.com> (sfid-20080228_143338_802398_02D5A55F)
References: <1204190255.3090.165.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1204190255.3090.165.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 28, 2008 at 05:17:35PM +0800, Zhu Yi wrote:
> Johannes,
> 
> What's the current state for hostapd and mac80211? I'm using below
> trees. Do I need to apply additional patches from your
> http://johannes.sipsolutions.net/patches/?
> 
> mac80211 from
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=summary

I'd guess you want the wireless-testing (or at least wireless-2.6.26) version.

-- 
John W. Linville
linville@tuxdriver.com
