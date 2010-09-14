Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab0INM72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 08:59:28 -0400
Subject: Re: [virtual-sta 1/3] mac80211:  Add more general interface
 iterator.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1284156298-15863-1-git-send-email-greearb@candelatech.com>
References: <1284156298-15863-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 14:59:26 +0200
Message-ID: <1284469166.3704.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-10 at 15:04 -0700, greearb@candelatech.com wrote:

> This allows callers to specify whether they want all
> or just active interfaces, 

I thought about this, and I don't want to allow drivers to get at
inactive interfaces. And with that, I don't think there's a need to
restructure the code here. Also, since what you wanted wasn't the count
but the STA interface count, you need your own iterator function anyway,
no?

johannes

