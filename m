Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:34921 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbbLPN5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 08:57:33 -0500
Received: by mail-qk0-f179.google.com with SMTP id u65so44798231qkh.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 05:57:33 -0800 (PST)
Date: Wed, 16 Dec 2015 08:57:29 -0500
From: "me@bobcopeland.com >> Bob Copeland" <me@bobcopeland.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
Message-ID: <20151216135729.GB4073@localhost> (sfid-20151216_145736_701734_40645923)
References: <5670DA9A.4010102@candelatech.com>
 <20151216132113.GA4073@localhost>
 <567166D0.5090000@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <567166D0.5090000@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 16, 2015 at 05:27:44AM -0800, Ben Greear wrote:
> >Does this patch cause problems for your userspace implementation?
> 
> Yes, because I coded with the assumptions that the radio addr had nothing
> to do with the vif addr.

I see -- but looking back at wmediumd history (before I had anything to
do with it) it seems it always had the opposite assumption -- e.g. the
ATTR_ADDR_TRANSMITTER mac address was compared against addresses in the
frame for delivery decisions.

-- 
Bob Copeland %% http://bobcopeland.com/
