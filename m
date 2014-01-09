Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55349 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaAIM55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 07:57:57 -0500
Message-ID: <1389272274.4348.3.camel@jlt4.sipsolutions.net> (sfid-20140109_135802_507012_7441D45A)
Subject: Re: [PATCH 1/2 v3] cfg80211: Add a function to get the number of
 supported channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 09 Jan 2014 13:57:54 +0100
In-Reply-To: <1389260243-22558-1-git-send-email-ilan.peer@intel.com> (sfid-20140109_103548_020854_FD4A2F1F)
References: <1389259051-18072-1-git-send-email-ilan.peer@intel.com>
	 <1389260243-22558-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20140109_103548_020854_FD4A2F1F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-09 at 11:37 +0200, Ilan Peer wrote:
> Add a utility function to get the number of channels supported by
> the device, and update the places in the code that need this data.

Applied with some fixes.

johannes

