Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4922 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab2JRH0Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 03:26:25 -0400
Message-ID: <507FAF19.6030500@broadcom.com> (sfid-20121018_092628_390987_B1CB0910)
Date: Thu, 18 Oct 2012 09:26:17 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Bing Zhao" <bzhao@marvell.com>
cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Sam Leffler" <sleffler@chromium.org>,
	"Amitkumar Karwar" <akarwar@marvell.com>
Subject: Re: [PATCH v6 3/6] cfg80211: add scan flag to indicate its
 priority
References: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
 <1350542071-26498-4-git-send-email-bzhao@marvell.com>
In-Reply-To: <1350542071-26498-4-git-send-email-bzhao@marvell.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2012 08:34 AM, Bing Zhao wrote:
> From: Sam Leffler <sleffler@chromium.org>
>
> Add NL80211_SCAN_FLAG_LOW_PRIORITY flag support. It tells drivers
> that this is a low priority scan request, so that they can take
> necessary action.
> Drivers need to advertise low priority scan capability during
> registration.

I missed the previous versions of this patch series, but what 'necessary 
action' is needed for a low priority scan request. Patch #6 gives a clue 
so my assumption is that a low prio scan will be *aborted* when 
associated and data traffic is available. Is that correct? Could it also 
*suspend* the low prio scan? Just curious whether there is an explicit 
behavioral requirement here. I probably should dig in previous versions 
of this patch series. Too bad the cover letter of this one does not have 
full change log.

Gr. AvS

