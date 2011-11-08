Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1KHUJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 15:09:11 -0500
Subject: Re: [PATCH v8 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320780995-30483-2-git-send-email-greearb@candelatech.com> (sfid-20111108_203659_989707_E33ECA13)
References: <1320780995-30483-1-git-send-email-greearb@candelatech.com>
	 <1320780995-30483-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111108_203659_989707_E33ECA13)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 21:09:09 +0100
Message-ID: <1320782949.24797.45.camel@jlt3.sipsolutions.net> (sfid-20111108_210915_288471_EC8C7293)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 11:36 -0800, greearb@candelatech.com wrote:

> +			/*
> +			 * We always need to advert at least MCS0-7, to
> +			 * be a compliant HT station, for instance
> +			 */
> +			if (((i * 8 + q) >= min_rates) &&

This is a little misleading -- why min_rates when the comment says
MCS0-7?

johannes

