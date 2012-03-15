Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39401 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031664Ab2COQ0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 12:26:07 -0400
Received: by yhmm54 with SMTP id m54so3285990yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 09:26:05 -0700 (PDT)
Message-ID: <4F62181A.7020304@lwfinger.net> (sfid-20120315_172613_667375_9C88D40D)
Date: Thu, 15 Mar 2012 11:26:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] cfg80211: allow CFG80211_SIGNAL_TYPE_UNSPEC in station_info
References: <1331825203.3432.25.camel@jlt3.sipsolutions.net> <1331827087-21339-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1331827087-21339-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2012 10:58 AM, John W. Linville wrote:
> The station_info struct had demanded dBm signal values, but the
> cfg80211 wireless extensions implementation was also accepting
> "unspecified" (i.e. RSSI) unit values while the nl80211 code was
> completely unaware of them.  Resolve this by formalling allowing the
                                                formally ?

Larry
