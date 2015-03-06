Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:34873 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbbCFISe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 03:18:34 -0500
MIME-Version: 1.0
In-Reply-To: <54F8E9A1.3040408@infradead.org>
References: <20150305143417.0c301f17@canb.auug.org.au>
	<54F8E9A1.3040408@infradead.org>
Date: Fri, 6 Mar 2015 10:18:32 +0200
Message-ID: <CANUX_P1_Zb1TEBtOkKbyFjJLGO6fJcE3Z7dSCRo9Q9NHMvn2Fw@mail.gmail.com> (sfid-20150306_091910_448837_70FE03F6)
Subject: Re: linux-next: Tree for Mar 5 (iwlwifi/mvm)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 6, 2015 at 1:41 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 03/04/15 19:34, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20150304:
>>
>
> on i386, when IWLWIFI_DEBUGFS is not enabled:
>
>
> ../drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c:179:38: error: 'struct iwl_mvm' has no member named 'dbgfs_rx_phyinfo'
> ../drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c:1378:30: error: 'struct iwl_mvm_vif' has no member named 'mvm'
>
>
Yes - I am sorry about that. I'll fix it on Sunday.
