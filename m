Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52166 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaKDI6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 03:58:05 -0500
Message-ID: <1415091473.2064.1.camel@sipsolutions.net> (sfid-20141104_095839_251181_61DEB17E)
Subject: Re: [PATCH] ieee80211: add "max length of AMPDU" enum for VHT
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Tue, 04 Nov 2014 09:57:53 +0100
In-Reply-To: <1415038007-2873-1-git-send-email-egrumbach@gmail.com> (sfid-20141103_190654_428213_77293E2E)
References: <1415038007-2873-1-git-send-email-egrumbach@gmail.com>
	 (sfid-20141103_190654_428213_77293E2E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-11-03 at 20:06 +0200, Emmanuel Grumbach wrote:
> From: Eran Harary <eran.harary@intel.com>
> 
> Maximum length of AMPDU that an STA can receive in VHT.
> length = 2 ^ (13 + max_ampdu_length_exp) - 1.

Applied.

johannes

