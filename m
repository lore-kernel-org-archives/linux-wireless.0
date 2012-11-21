Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56809 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2KUOSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 09:18:15 -0500
Date: Wed, 21 Nov 2012 08:18:12 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [wireless-next:master 203/214]
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:573:17: sparse: Using
 plain integer as NULL pointer
Message-ID: <20121121141812.GB23606@thinkpad-t410> (sfid-20121121_151819_129980_3BC401BF)
References: <50ac819d.deUknDDzRBMUnMNp%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50ac819d.deUknDDzRBMUnMNp%fengguang.wu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 21, 2012 at 03:24:13PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
> head:   e2ff0498409af6f2023f91aba07b281e5e87ee15
> commit: b353dda485038d5033b066cc946dfcf66afae128 [203/214] brcmsmac: Use debug macros for general error and debug statements
> 
> 
> sparse warnings:
> 
> + drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:573:17: sparse: Using plain integer as NULL pointer

There's actually a bug here. I'll send a patch.

Seth

