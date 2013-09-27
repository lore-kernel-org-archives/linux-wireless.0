Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54927 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab3I0E0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 00:26:10 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Joe Perches <joe@perches.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 08/11] iwlwifi: Remove extern from function prototypes
Date: Fri, 27 Sep 2013 04:25:54 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DB4D7E@HASMSX103.ger.corp.intel.com> (sfid-20130927_062632_743388_945F4CE3)
References: <cover.1380137609.git.joe@perches.com>
 <b3818394ccdf68d834ca1060c1d5a1fc44e2daee.1380137610.git.joe@perches.com>
In-Reply-To: <b3818394ccdf68d834ca1060c1d5a1fc44e2daee.1380137610.git.joe@perches.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Subject: [PATCH 08/11] iwlwifi: Remove extern from function prototypes
> 
> There are a mix of function prototypes with and without extern in the kernel
> sources.  Standardize on not using extern for function prototypes.
> 
> Function prototypes don't need to be written with extern.
> extern is assumed by the compiler.  Its use is as unnecessary as using auto to
> declare automatic/local variables in a block.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/iwlwifi/dvm/agn.h | 2 +-
> drivers/net/wireless/iwlwifi/dvm/dev.h | 2 +-
> drivers/net/wireless/iwlwifi/dvm/rs.h  | 8 ++++----
> drivers/net/wireless/iwlwifi/mvm/rs.h  | 9 ++++-----
>  4 files changed, 10 insertions(+), 11 deletions(-)
> 

ACK
