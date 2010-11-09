Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42092 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab0KITpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 14:45:03 -0500
Date: Tue, 9 Nov 2010 14:39:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH wireless-2.6] iwlwifi: dont use pci_dev before it being
 assign
Message-ID: <20101109193917.GC2374@tuxdriver.com>
References: <1289270721-31421-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1289270721-31421-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 08, 2010 at 06:45:21PM -0800, Wey-Yi Guy wrote:
> In order to use build-in debugging macro, pci_dev in priv need to be
> assigned first.
> 
> This fix iwl3945 driver oopsed at boot with 2.6.37-rc1
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
> this patch is also available from wireless-2.6 branch on
>  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

I tried to pull this, but it seemed to be the wrong patch.  I manually
applied the posted patch instead.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
