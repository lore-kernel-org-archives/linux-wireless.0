Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45139 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbbIDFwV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 01:52:21 -0400
Message-ID: <1441345939.1971.0.camel@sipsolutions.net> (sfid-20150904_075224_620375_E5466E78)
Subject: Re: [PATCH] mac80211: fix the setting of center freq segment 2 in
 VHT oper ie
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 04 Sep 2015 07:52:19 +0200
In-Reply-To: <1441335485-5314-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150904_045832_710587_B8EF75CF)
References: <1441335485-5314-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20150904_045832_710587_B8EF75CF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-09-04 at 10:58 +0800, Chun-Yeow Yeoh wrote:
> This is to avoid the Channel Center Frequency Segment 2
> in broadcasted VHT operation element contains the non-zero
> value for non 80+80 MHz that may failed the comparison of
> cfg80211_chandef_identical.
> 
> This is tested with Bob's patches related to VHT mesh support.
> 
I suppose I'll squash this into the appropriate of Bob's patches :)

johannes
