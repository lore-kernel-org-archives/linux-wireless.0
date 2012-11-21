Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56772 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2KUOM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 09:12:56 -0500
Date: Wed, 21 Nov 2012 08:12:49 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [wireless-next:master 196/214]
 drivers/net/wireless/brcm80211/brcmsmac/main.c:308:10: sparse: symbol
 'wlc_prio2prec_map' was not declared. Should it be static?
Message-ID: <20121121141249.GA23606@thinkpad-t410> (sfid-20121121_151305_582549_D4C45879)
References: <50ac7bc7.tSErItiXQxTyHiGi%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50ac7bc7.tSErItiXQxTyHiGi%fengguang.wu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 21, 2012 at 02:59:19PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
> head:   e2ff0498409af6f2023f91aba07b281e5e87ee15
> commit: e041f65d5f00011049c7d6af0e31ce69ce9e2655 [196/214] brcmsmac: Remove internal tx queue
> 
> 
> sparse warnings:
> 
> + drivers/net/wireless/brcm80211/brcmsmac/main.c:308:10: sparse: symbol 'wlc_prio2prec_map' was not declared. Should it be static?
> drivers/net/wireless/brcm80211/brcmsmac/main.c:6500:43:   also defined here
> 
> Please consider folding the attached diff :-)

Actually this just isn't used anymore. I'll send a patch to remove it
next week when I'm back from holiday.

Seth

