Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41904 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbbCEXl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 18:41:27 -0500
Message-ID: <54F8E9A1.3040408@infradead.org> (sfid-20150306_004149_267281_0A8D6095)
Date: Thu, 05 Mar 2015 15:41:21 -0800
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: Re: linux-next: Tree for Mar 5 (iwlwifi/mvm)
References: <20150305143417.0c301f17@canb.auug.org.au>
In-Reply-To: <20150305143417.0c301f17@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/04/15 19:34, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20150304:
> 

on i386, when IWLWIFI_DEBUGFS is not enabled:


../drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c:179:38: error: 'struct iwl_mvm' has no member named 'dbgfs_rx_phyinfo'
../drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c:1378:30: error: 'struct iwl_mvm_vif' has no member named 'mvm'


-- 
~Randy
