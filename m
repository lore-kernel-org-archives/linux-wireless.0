Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaBFIeB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 03:34:01 -0500
Message-ID: <1391675634.12789.0.camel@jlt4.sipsolutions.net> (sfid-20140206_093405_418095_F1CA4CD0)
Subject: Re: [PATCH v2] mac80211: remove unused radiotap vendor fields in
 ieee80211_rx_status
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: k.eugene.e@gmail.com, linux-wireless@vger.kernel.org
Date: Thu, 06 Feb 2014 09:33:54 +0100
In-Reply-To: <1391610961-29019-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1391610961-29019-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-05 at 16:36 +0200, Emmanuel Grumbach wrote:
> The purpose of this housekeeping is to make some room for
> VHT flags. The radiotap vendor fields weren't in use.

Applied.

johannes

