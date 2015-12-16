Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:35277 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbbLPOdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 09:33:54 -0500
Received: by mail-qk0-f175.google.com with SMTP id u65so46637285qkh.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 06:33:53 -0800 (PST)
Date: Wed, 16 Dec 2015 09:33:47 -0500
From: "me@bobcopeland.com >> Bob Copeland" <me@bobcopeland.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
Message-ID: <20151216143346.GD4073@localhost> (sfid-20151216_153358_679877_02DBE039)
References: <5670DA9A.4010102@candelatech.com>
 <20151216132113.GA4073@localhost>
 <567166D0.5090000@candelatech.com>
 <20151216135729.GB4073@localhost>
 <56717226.80000@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56717226.80000@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 16, 2015 at 06:16:06AM -0800, Ben Greear wrote:
> Even so, I think it is more important to keep the kernel API stable than
> to work around issues in relatively obscure user-space apps.

Let's face it, everything using hwsim netlink api is already obscure :)

-- 
Bob Copeland %% http://bobcopeland.com/
