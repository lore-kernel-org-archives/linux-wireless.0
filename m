Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59277 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbbDGQIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 12:08:21 -0400
Message-ID: <552400F4.5010701@candelatech.com> (sfid-20150407_180824_557093_A9ED31C2)
Date: Tue, 07 Apr 2015 09:08:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Ilan Peer <ilan.peer@intel.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211_hwsim: Set VHT capabilities only for the
 5.2 GHz band
References: <1428422722-655-1-git-send-email-ilan.peer@intel.com>
In-Reply-To: <1428422722-655-1-git-send-email-ilan.peer@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/07/2015 09:05 AM, Ilan Peer wrote:
> Previously, VHT capabilities and supported MCSs where set for all
> bands, although VHT is only allowed on 5.2 GHz band. Fix it.

I saw a patch on ath10k list that enabled VHT for 2.4Ghz for
that driver/firmware...are you sure it is absolutely not supported?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

