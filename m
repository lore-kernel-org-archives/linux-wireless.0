Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7025 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbZLBE1R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 23:27:17 -0500
Subject: Re: [PATCH] mac80211: allow disabling 40MHz on 2.4GHz
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1259718190.32171.146.camel@johannes.local>
References: <1259688582.32171.97.camel@johannes.local>
	 <1259691446.4806.12.camel@mj>  <1259692053.32171.98.camel@johannes.local>
	 <43e72e890912011118w535781a4id4e4572df16267f4@mail.gmail.com>
	 <1259716754.11611.6.camel@mj>  <1259718190.32171.146.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 01 Dec 2009 23:26:55 -0500
Message-Id: <1259728015.4088.0.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-12-02 at 02:43 +0100, Johannes Berg wrote:

> And I would argue that it is -- module parameters are still discouraged,
> that doesn't change with adding one. We currently have one in mac80211
> to chose the rate control algorithm, but it too is a special case and
> ought to not be required.
> 
> I don't see this parameter as configuration like ack timeout or 10mhz
> channels or ... I think this parameter solves a systems integration
> issue, not a configuration issue.

OK, fair enough.

-- 
Regards,
Pavel Roskin
