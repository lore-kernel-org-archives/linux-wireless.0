Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:51761 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933576AbZKXRlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 12:41:09 -0500
Date: Tue, 24 Nov 2009 19:41:05 +0200
From: Jouni Malinen <j@w1.fi>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: Re: [RFC 1/3] nl80211: PMKSA caching support
Message-ID: <20091124174105.GA17213@jm.kir.nu>
References: <cover.1259075573.git.sameo@linux.intel.com>
 <ff5bf1a69ecd3ed3695089cf62e6ab51689b683a.1259075573.git.sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ff5bf1a69ecd3ed3695089cf62e6ab51689b683a.1259075573.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 24, 2009 at 04:26:52PM +0100, Samuel Ortiz wrote:
> This is an interface to set, delete and flush PMKIDs through nl80211.
> Main users would be fullmac devices which firmwares are capable of generating
> the RSN IEs for the re-association requests, e.g. iwmc3200wifi.

Is there a maximum number of PMKSA cache entries that the driver can
handle? If so, it might be useful to provide a mechanism to indicate
that limit (e.g., something similar to NL80211_ATTR_MAX_NUM_SCAN_SSIDS).

-- 
Jouni Malinen                                            PGP id EFC895FA
