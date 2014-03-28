Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaC1NIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:08:32 -0400
Message-ID: <1396012109.4175.26.camel@jlt4.sipsolutions.net> (sfid-20140328_140834_947301_941C4AA5)
Subject: Re: [PATCH v2 07/13] mac80211: improve find_chanctx() for
 reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 14:08:29 +0100
In-Reply-To: <1395409651-26120-8-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145340_786158_B396141D)
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-8-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140321_145340_786158_B396141D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 14:47 +0100, Michal Kazior wrote:
> Relax ieee80211_find_chanctx(). If chanctx
> reservation chandef is compatible with
> current-future assigned interfaces chandef then
> allow it to be used by new interfaces.

Err, I don't understand. Could you elaborate?

johannes

