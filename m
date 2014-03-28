Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaC1IoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 04:44:05 -0400
Message-ID: <1395996240.4175.7.camel@jlt4.sipsolutions.net> (sfid-20140328_094411_120419_AB5D5549)
Subject: Re: [PATCH v2 1/3] mac80211: move flag
 IEEE80211_TX_CTL_FIRST_FRAGMENT into info->control.flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@nbd.name
Date: Fri, 28 Mar 2014 09:44:00 +0100
In-Reply-To: <1394550902-1228-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1394550902-1228-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1394550902-1228-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-11 at 16:15 +0100, Thomas Huehn wrote:
> Flag IEEE80211_TX_CTL_FIRST_FRAGMENT is only used within the tx path while
> ieee80211_tx_info->control is valid. Therefore this patch moves this flag
> from info->flags structure into the info->control.flags and renames it to
> IEEE80211_TX_CTRL_FIRST_FRAGMENT.

Your commit logs are inadequate. Apart from the formatting problem
(lines too long, should be 72 chars at most) you're not describing why
you're making the changes.

johannes

