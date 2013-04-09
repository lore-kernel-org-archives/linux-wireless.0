Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173Ab3DIJjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 05:39:51 -0400
Message-ID: <1365500387.8465.7.camel@jlt4.sipsolutions.net> (sfid-20130409_113958_750337_D32342CF)
Subject: Re: [PATCH 1/6] mac80211: unset FC retry bit in mesh fwding path
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Tue, 09 Apr 2013 11:39:47 +0200
In-Reply-To: <1365444377-9959-1-git-send-email-thomas@cozybit.com> (sfid-20130408_200759_469758_60CEE9C3)
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130408_200759_469758_60CEE9C3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-08 at 11:06 -0700, Thomas Pedersen wrote:
> Otherwise forwarded frames would keep the retry bit set
> from the previous link transmission.

Applied.

johannes

