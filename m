Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab3LCMrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 07:47:41 -0500
Message-ID: <1386074858.4393.9.camel@jlt4.sipsolutions.net> (sfid-20131203_134744_547338_E8182C87)
Subject: Re: [PATCH 1/2 V3] nl80211/cfg80211: Set Operating Mode Notification
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Dec 2013 13:47:38 +0100
In-Reply-To: <1386061500-5750-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131203_100517_923549_5D57D5B6)
References: <1386061500-5750-1-git-send-email-marek.kwaczynski@tieto.com>
	 (sfid-20131203_100517_923549_5D57D5B6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 10:04 +0100, Marek Kwaczynski wrote:
> This attribuite is needed for setting Operating Mode Notification
> in AP mode from User Space. This functionality is required when
> User Space received Assoc Reqeust contains Operation Mode
> Notification element.

Applied.

johannes

