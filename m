Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:55179 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab0CXUUx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 16:20:53 -0400
Message-ID: <4BAA73D2.1000301@oracle.com>
Date: Wed, 24 Mar 2010 13:19:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for March 24 (iwlwifi)
References: <20100324161746.85edc5a3.sfr@canb.auug.org.au>
In-Reply-To: <20100324161746.85edc5a3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/23/10 22:17, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100323:


drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_good_ack_health':
drivers/net/wireless/iwlwifi/iwl-rx.c:647: error: 'struct iwl_priv' has no member named '_agn'

when CONFIG_IWLAGN is not enabled.



-- 
~Randy
