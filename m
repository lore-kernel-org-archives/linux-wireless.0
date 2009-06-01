Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60870 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZFASa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 14:30:27 -0400
Date: Mon, 1 Jun 2009 14:29:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
Message-ID: <20090601182940.GC3386@tuxdriver.com>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com> <1243307448-17441-2-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243307448-17441-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 26, 2009 at 11:10:47AM +0800, Zhu Yi wrote:
> From: Samuel Ortiz <samuel.ortiz@intel.com>
> 
> Firmware names can not be longer than 30 characters, and
> iwmc3200wifi-lmac-calib-sdio.bin is too long.
> Renaming it to iwmc3200wifi-calib-sdio.bin.
> 
> Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Is this still wanted?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
