Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838AbaEFGuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 02:50:19 -0400
Message-ID: <1399358996.4218.0.camel@jlt4.sipsolutions.net> (sfid-20140506_085022_565983_4C4CB1FA)
Subject: Re: [PATCH 1/2] mac80211: add no update durationId bit in radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Date: Tue, 06 May 2014 08:49:56 +0200
In-Reply-To: <1399357967-6541-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140506_083453_040307_EBA00D92)
References: <1399357967-6541-1-git-send-email-marek.kwaczynski@tieto.com>
	 (sfid-20140506_083453_040307_EBA00D92)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-06 at 08:32 +0200, Marek Kwaczynski wrote:
> Adds a new bit in radiotap_tx flags, which allows injections
> frames without changing durationId filed. The intention is
> a NAV update testing.

NACK.

http://www.radiotap.org/suggested-fields/TX%20flags

And since I'm tired of this, I'll make any further radiotap updates to
this particular field contingent on somebody actually standardising it
properly.

johannes

