Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:18825 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYG1N4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 09:56:43 -0400
Received: by ug-out-1314.google.com with SMTP id h2so31768ugf.16
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 06:56:41 -0700 (PDT)
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200807281544.33509.mb@bu3sch.de>
References: <48763814.27052c0a.1794.2095@mx.google.com>
	 <1217172136.2700.21.camel@localhost.localdomain>
	 <1217251433.12662.5.camel@johannes.berg>  <200807281544.33509.mb@bu3sch.de>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 15:56:37 +0200
Message-Id: <1217253397.6364.2.camel@localhost> (sfid-20080728_155646_607452_FCBC45C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-28 at 15:44 +0200, Michael Buesch wrote:
> Well, I think that really is pretty weird and it is confusing to the
> user to see that pseudo random MAC that changes suddenly when the device is
> initialized. For the human user (so everybody but me), it would be better
> to have the MAC all-zeros until the firmware loaded. So it would be obvious
> that the MAC is not set, yet. I think userspace

The problem is that all-zeroes is actually a valid mac address, owned by
Xerox (http://standards.ieee.org/regauth/oui/oui.txt) Not that it will
probably cause us any problem, but a multicast address is afaik an
invalid mac for a device. Should we go for 01:allzeros?


-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


