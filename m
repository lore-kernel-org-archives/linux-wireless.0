Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaAGPYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 10:24:09 -0500
Message-ID: <1389108247.4645.5.camel@jlt4.sipsolutions.net> (sfid-20140107_162413_730228_8F17C0E9)
Subject: Re: [PATCH 2/2] mac80211: simplify code in
 ieee80211_prepare_and_rx_handle
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Jan 2014 16:24:07 +0100
In-Reply-To: <1389093020-12005-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1389093020-12005-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-07 at 13:10 +0200, Emmanuel Grumbach wrote:
> No need to assign the return value of prepare_for_handlers
> to a variable if the only usage is to test it.

Applied.

johannes

