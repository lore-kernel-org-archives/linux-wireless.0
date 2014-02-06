Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbaBFIfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 03:35:47 -0500
Message-ID: <1391675744.12789.2.camel@jlt4.sipsolutions.net> (sfid-20140206_093550_823799_0B0BCF5E)
Subject: Re: [PATCH 3/3] mac80211: propagate STBC / LDPC flags to radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 06 Feb 2014 09:35:44 +0100
In-Reply-To: <1391597333-6398-3-git-send-email-emmanuel.grumbach@intel.com>
References: <1391597333-6398-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1391597333-6398-3-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-05 at 12:48 +0200, Emmanuel Grumbach wrote:
> This capabilities weren't propagated to the radiotap header.
> We don't set here the VHT_KNOWN / MCS_HAVE flag because not
> all the low level drivers will know how to properly flag
> the frames, hence the low level driver will be in charge
> of setting IEEE80211_RADIOTAP_MCS_HAVE_FEC,
> IEEE80211_RADIOTAP_MCS_HAVE_STBC and / or
> IEEE80211_RADIOTAP_VHT_KNOWN_STBC according to its
> capabilities.

Applied.

johannes

