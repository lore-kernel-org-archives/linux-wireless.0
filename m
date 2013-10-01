Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3JAKU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 06:20:58 -0400
Message-ID: <1380622855.14430.8.camel@jlt4.sipsolutions.net> (sfid-20131001_122101_199171_8AA7FF0A)
Subject: Re: [PATCH] mac80211: use exact-size allocation for authentication
 frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Fred Zhou <fred.zy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 12:20:55 +0200
In-Reply-To: <1379989981-3440-1-git-send-email-fred.zy@gmail.com> (sfid-20130924_043251_239596_6C9396B7)
References: <1379989981-3440-1-git-send-email-fred.zy@gmail.com>
	 (sfid-20130924_043251_239596_6C9396B7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-24 at 10:33 +0800, Fred Zhou wrote:
> The authentication frame has a fixied size of 30 bytes
> (including header, algo num, trans seq num, and status)
> followed by a variable challenge text.
> Allocate using exact size, instead of over-allocation
> by sizeof(ieee80211_mgmt).

Applied (a slightly modified version)

johannes

