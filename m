Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58960 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab0KXR3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 12:29:45 -0500
Date: Wed, 24 Nov 2010 12:28:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/5] update for 2.6.38
Message-ID: <20101124172848.GF7435@tuxdriver.com>
References: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 23, 2010 at 10:58:51AM -0800, Wey-Yi Guy wrote:
> We add advance power management support for newer devices
> We also consider BT coex and shadow register as part of power management
> 
> Wey-Yi Guy (5):
>   iwlagn: name change for BT config flag
>   iwlwifi: add more power management flags
>   iwlwifi: consider BT for power management
>   iwlwifi: power management checking for shadow register
>   iwlwifi: advance power management support
> 
> these patches are also available from wireless-next-2.6 branch on
>  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Since I had to rebase wireless-next-2.6, this pull wasn't good.
I applied the patches manually.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
