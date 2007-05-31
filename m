Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4735 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbXEaT26 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2007 15:28:58 -0400
Date: Thu, 31 May 2007 14:04:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [TAKE 2][PATCH 0/3] IEEE802.11e/WMM TS management and DLS support
Message-ID: <20070531180445.GB3706@tuxdriver.com>
References: <20070525115205.GA23301@mail.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070525115205.GA23301@mail.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 25, 2007 at 07:52:05PM +0800, Zhu Yi wrote:

> The following patches updated my previous IEEE802.11e/WMM patches
> based on the comments from Michael Wu. Please apply.
> 
> [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
> [PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS support
> [PATCH 3/3] mac80211: debugfs support for TSM and DLS

Yi,

Please also submit a patch series that applies against linux-2.6.22-rc3
(or later) and adds whatever else might be needed that is missing
there.  This one changes code that is currently only in wireless-dev.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
