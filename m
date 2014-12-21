Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58659 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbaLUWJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 17:09:51 -0500
Message-ID: <1419199788.2387.5.camel@sipsolutions.net> (sfid-20141221_230954_339906_34B66863)
Subject: Re: [PATCH 2/2] mac80211: allow some multi-channel combinations
 with DFS master
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 21 Dec 2014 23:09:48 +0100
In-Reply-To: <1419179546-29313-2-git-send-email-eliad@wizery.com> (sfid-20141221_173231_578831_6AC3F6DF)
References: <1419179546-29313-1-git-send-email-eliad@wizery.com>
	 <1419179546-29313-2-git-send-email-eliad@wizery.com>
	 (sfid-20141221_173231_578831_6AC3F6DF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-12-21 at 18:32 +0200, Eliad Peller wrote:
> Allow some multi-channel interface combinations along with
> DFS master support, if there is only a single AP/GO.
> 
> Allowing other interface types at the same time is fine

I don't believe this to be true - how are you going to do radar
detection accurately if you're spending any amount of time on another
channel?

johannes

