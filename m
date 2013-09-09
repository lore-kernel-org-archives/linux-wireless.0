Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3IIPLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 11:11:32 -0400
Message-ID: <1378739484.18731.2.camel@jlt4.sipsolutions.net> (sfid-20130909_171135_243430_A9C3219D)
Subject: Re: [PATCH] mac80211: do not check duplicate IEs when parsing
 elements.
From: Johannes Berg <johannes@sipsolutions.net>
To: Fred Zhou <fred.zy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Sep 2013 17:11:24 +0200
In-Reply-To: <1378698114-18930-1-git-send-email-fred.zy@gmail.com> (sfid-20130909_054218_932044_429D079D)
References: <1378698114-18930-1-git-send-email-fred.zy@gmail.com>
	 (sfid-20130909_054218_932044_429D079D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-09 at 11:41 +0800, Fred Zhou wrote:
>  The 802.11 standard does not prevent the same IE to be
>  included in one frame (e.g. beacon)  multiple times.

Actually, it does say that the IEs must be in a given order, with
exactly the IEs (except for the ones that are allowed multiple times
etc.)

johannes

