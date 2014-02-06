Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaBFIep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 03:34:45 -0500
Message-ID: <1391675679.12789.1.camel@jlt4.sipsolutions.net> (sfid-20140206_093447_905399_916E8A31)
Subject: Re: [PATCH v2] mac80211: move VHT related RX_FLAG to another
 variable
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 06 Feb 2014 09:34:39 +0100
In-Reply-To: <1391611031-29099-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1391611031-29099-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-05 at 16:37 +0200, Emmanuel Grumbach wrote:
> ieee80211_rx_status.flags is full. Define a new vht_flag
> variable to be able to set more VHT related flags and make
> room in flags.

Applied.

johannes

