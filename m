Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3JKNxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 09:53:16 -0400
Message-ID: <1381499593.14293.20.camel@jlt4.sipsolutions.net> (sfid-20131011_155319_111095_F63209B9)
Subject: Re: [PATCH] mac80211: implement SMPS for AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Oct 2013 15:53:13 +0200
In-Reply-To: <1380635144-12875-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131001_154552_593349_347408B4)
References: <1380635144-12875-1-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20131001_154552_593349_347408B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied, but

> +		for (i = 7; i <= 0; i--)

Fixed that to be >=
(smatch found it)

johannes

