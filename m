Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:30671 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934252AbZKXWs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 17:48:56 -0500
Date: Tue, 24 Nov 2009 23:50:42 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: Re: [RFC 1/3] nl80211: PMKSA caching support
Message-ID: <20091124225041.GA8290@sortiz.org>
References: <cover.1259075573.git.sameo@linux.intel.com>
 <ff5bf1a69ecd3ed3695089cf62e6ab51689b683a.1259075573.git.sameo@linux.intel.com>
 <20091124174105.GA17213@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091124174105.GA17213@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

On Tue, Nov 24, 2009 at 07:41:05PM +0200, Jouni Malinen wrote:
> On Tue, Nov 24, 2009 at 04:26:52PM +0100, Samuel Ortiz wrote:
> > This is an interface to set, delete and flush PMKIDs through nl80211.
> > Main users would be fullmac devices which firmwares are capable of generating
> > the RSN IEs for the re-association requests, e.g. iwmc3200wifi.
> 
> Is there a maximum number of PMKSA cache entries that the driver can
> handle? If so, it might be useful to provide a mechanism to indicate
> that limit (e.g., something similar to NL80211_ATTR_MAX_NUM_SCAN_SSIDS).
Good point. I'll add that to the patch.

Cheers,
Samuel.

> -- 
> Jouni Malinen                                            PGP id EFC895FA

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
