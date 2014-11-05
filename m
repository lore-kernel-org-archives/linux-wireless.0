Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34072 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbaKEKMH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 05:12:07 -0500
Message-ID: <1415182321.2589.14.camel@sipsolutions.net> (sfid-20141105_111212_842708_C366D72A)
Subject: Re: [PATCH v2] ath10k: handle ieee80211 header and payload tracing
 separately
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 05 Nov 2014 11:12:01 +0100
In-Reply-To: <20141105094437.GA21839@qca.qualcomm.com> (sfid-20141105_104310_542370_58A02806)
References: <1414661336-20764-1-git-send-email-rmanohar@qti.qualcomm.com>
	 <874muf7t9u.fsf@kamboji.qca.qualcomm.com>
	 <20141104051643.GA14509@qca.qualcomm.com>
	 <87k33a1lli.fsf@kamboji.qca.qualcomm.com>
	 <20141105094437.GA21839@qca.qualcomm.com>
	 (sfid-20141105_104310_542370_58A02806)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-05 at 15:14 +0530, Rajkumar Manoharan wrote:

> The macro is defined to ease readability and reduce # of line changes.
> I originally thought of naming the macro as IEEE80211_HDR_LEN. But such
> definition does not look correct inside driver.

FWIW, I pointed Kalle to the macro on IRC - IMHO you should pass
arguments to the macro (and probably even make it an inline function)
rather than having it assume certain variables exist when the macro is
used.

Kalle may have misunderstood what I was trying to say :)

johannes

