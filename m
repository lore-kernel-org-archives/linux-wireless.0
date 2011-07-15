Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65450 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965172Ab1GOKuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 06:50:01 -0400
Received: by ywe9 with SMTP id 9so479136ywe.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 03:50:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
Date: Fri, 15 Jul 2011 14:50:00 +0400
Message-ID: <CAMo8BfKk+c_Ywjd-mJ4N5zAUxr4t5sRQC4Gq-UrbSW2WwDUnPg@mail.gmail.com> (sfid-20110715_125015_412036_0048B28C)
Subject: Re: [PATCH 0/5] mac80211: mesh beaconing
From: Max Filippov <jcmvbkbc@gmail.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Currently, mesh beacons have IEs either missing or in the wrong order. Update
> the mesh beacon to the proper format specified in 802.11s draft 12.0. This

Thomas, what is the exact draft version number?

> patch set will be part of a greater effort to update the mesh stack in mac80211
> in anticipation of the ratification of the 802.11s standard.

-- 
Thanks.
-- Max
