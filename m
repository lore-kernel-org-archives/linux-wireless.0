Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42716 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbbALVgk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 16:36:40 -0500
Message-ID: <1421098594.1891.34.camel@sipsolutions.net> (sfid-20150112_223643_906851_E9A82854)
Subject: Re: [PATCH] iwlwifi: document switch case fall-through in
 iwl_mvm_send_sta_key
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>, ilw@linux.intel.com
Date: Mon, 12 Jan 2015 22:36:34 +0100
In-Reply-To: <1421097491-29574-1-git-send-email-linville@tuxdriver.com> (sfid-20150112_223024_176525_753A4630)
References: <1421097491-29574-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20150112_223024_176525_753A4630)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-12 at 16:18 -0500, John W. Linville wrote:
> Add a comment indicating that the WLAN_CIPHER_SUITE_WEP104 case falls
> through to the WLAN_CIPHER_SUITE_WEP40 case in iwl_mvm_send_sta_key.
> This will document that the lack of a break is intentional.
> 
> Coverity: CID 1260023
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> This seems to work, so I'm guessing that the fall-through is
> intentional...

Yeah, it is.

johannes

