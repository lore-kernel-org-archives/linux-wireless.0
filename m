Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38742 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3HPK0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 06:26:50 -0400
Message-ID: <1376648807.15299.6.camel@jlt4.sipsolutions.net> (sfid-20130816_122716_026248_3E81BD43)
Subject: Re: [PATCHv2 3/6] mac80211: move ibss presp generation in own
 function
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 16 Aug 2013 12:26:47 +0200
In-Reply-To: <1376058920-17779-4-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1376058920-17779-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1376058920-17779-4-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-09 at 16:35 +0200, Simon Wunderlich wrote:
> Channel Switch will later require to generate beacons without setting
> them immediately. Therefore split the presp generation in an own
> function. Splitting the original very long function might be a good idea
> anyway.

Applied.

johannes

