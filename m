Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:64208 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZHHTeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 15:34:37 -0400
Received: by rv-out-0506.google.com with SMTP id k40so393449rvb.5
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 12:34:36 -0700 (PDT)
Message-ID: <4A7DD307.6090209@lwfinger.net>
Date: Sat, 08 Aug 2009 14:33:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH v4] cfg80211: validate channel settings across interfaces
References: <1249649261.4215.7.camel@johannes.local>	 <1249649433.7194.0.camel@johannes.local>	 <1249652951.7194.2.camel@johannes.local>	 <1249658555.7194.8.camel@johannes.local> <1249712383.30019.5561.camel@rc-desk>
In-Reply-To: <1249712383.30019.5561.camel@rc-desk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre wrote:
> Hi Johannes,
> 
> This patch is now in wireless-testing and it is causing a problem for
> me. This was determined using bisect.
> 
> I am able to bring the interface up and scan, but when I try to
> associate I get a hang.
> 
> For example, when I run:
> $ iwconfig wlan0 channel <ch> essid <essid>
> 
> then the command prompt never returns and system becomes progressively
> unresponsive. The logs do not contain any details of the problem.

I have the same problem here as well.

Larry

