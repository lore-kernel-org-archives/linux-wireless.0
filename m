Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab3EMJmo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 05:42:44 -0400
Message-ID: <1368438160.8300.11.camel@jlt4.sipsolutions.net> (sfid-20130513_114249_029259_9C6EC440)
Subject: Re: [PATCH 2/3] cfg80211: Allow ieee80211g mandatory rate sets in
 2.4GHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Mon, 13 May 2013 11:42:40 +0200
In-Reply-To: <1368233453-10581-2-git-send-email-ashok@cozybit.com> (sfid-20130511_025108_024609_B2866B0C)
References: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
	 <1368233453-10581-2-git-send-email-ashok@cozybit.com>
	 (sfid-20130511_025108_024609_B2866B0C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-10 at 17:50 -0700, Ashok Nagarajan wrote:
> This patch assumes 11g support
> implies a 11g operation and returns the appropriate mandatory rates.

Which is a problem, because it means that by default we'll create IBSS
networks that are not compatible with 11b devices.

johannes

