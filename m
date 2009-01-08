Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17859 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZAHFqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 00:46:36 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: move dynamic PS timeout to hardware config
References: <1231261998.3654.2.camel@johannes>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 08 Jan 2009 07:45:46 +0200
In-Reply-To: <1231261998.3654.2.camel@johannes> (ext Johannes Berg's message of "Tue\, 06 Jan 2009 18\:13\:18 +0100")
Message-ID: <87aba2e4fp.fsf@nokia.com> (sfid-20090108_064648_965839_93CEB621)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Johannes Berg" <johannes@sipsolutions.net> writes:

> This will be needed for drivers that set the
> IEEE80211_HW_NO_STACK_DYNAMIC_PS flag and still
> want to handle dynamic PS.

Very good, at least iwlwifi can make use of this.

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Reviewed-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
