Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46240 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbZIYTi0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 15:38:26 -0400
Received: by fxm18 with SMTP id 18so2463471fxm.17
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 12:38:30 -0700 (PDT)
Message-ID: <4ABD1C37.3030102@lwfinger.net>
Date: Fri, 25 Sep 2009 14:38:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problems with WPA in mainline 2.6.31-gitX
References: <4ABD0B0D.5020002@lwfinger.net> <200909252042.37881.chunkeey@googlemail.com>
In-Reply-To: <200909252042.37881.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> 
> it made it into 2.6.31-git16:
> "cfg80211: don't overwrite privacy setting"
> 94f85853324e02c3a32bc3101f090dc9a3f512b4
> 
> but, "[PATCH] cfg80211: don't set privacy w/o key"
> is still missing.

Thanks, Christian. It turns out I do not need "don't set privacy".

With the latest pull, my system works fine.

Larry
