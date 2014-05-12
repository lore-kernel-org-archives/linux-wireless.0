Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:50038 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaELGrF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 02:47:05 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Subject: Re: [PATCH 1/7] cfg80211: don't set reg timeout for user-handled hint
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
	<1399798250-20987-2-git-send-email-emmanuel.grumbach@intel.com>
Date: Mon, 12 May 2014 09:47:00 +0300
In-Reply-To: <1399798250-20987-2-git-send-email-emmanuel.grumbach@intel.com>
	(Emmanuel Grumbach's message of "Sun, 11 May 2014 11:50:44 +0300")
Message-ID: <87egzz4hp7.fsf@purkki.adurom.net> (sfid-20140512_084709_874164_95DDF823)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> From: Arik Nemtsov <arik@wizery.com>
>
> Otherwise every "indoor" setting by usermode will cause a regdomain reset.
>
> Change-Id: I3225325d9fb956174458d386d4dd0f4e069deb58
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the patches in the series have the useless Change-Id tag.

-- 
Kalle Valo
