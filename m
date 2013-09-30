Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab3I3O34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 10:29:56 -0400
Message-ID: <1380551391.14467.14.camel@jlt4.sipsolutions.net> (sfid-20130930_162959_072208_49583D3C)
Subject: Re: [PATCH v2] cfg80211: don't start p2p device while in RFKILL
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Sep 2013 16:29:51 +0200
In-Reply-To: <1379421036-6206-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130917_143043_928522_5267EEDF)
References: <1379421036-6206-1-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20130917_143043_928522_5267EEDF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-17 at 15:30 +0300, Emmanuel Grumbach wrote:
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
> v2: Check the rfkill before adding the interface

I'll apply a fixed version that removes the check from the netdev
notifier where it would now be duplicate.

johannes

