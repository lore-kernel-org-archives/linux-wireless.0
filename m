Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37998 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSOQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:16:08 -0400
Message-ID: <1395238565.4142.18.camel@jlt4.sipsolutions.net> (sfid-20140319_151612_582787_DB4D3827)
Subject: Re: [PATCH] mac80211: set beamforming bit in radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Mar 2014 15:16:05 +0100
In-Reply-To: <1393922125-17383-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1393922125-17383-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-04 at 10:35 +0200, Emmanuel Grumbach wrote:
> Add a bit in rx_status.vht_flags to let the low level driver
> notify mac80211 about a beamformed packet. Propagate this
> to the radiotap header.

Applied.

johannes

