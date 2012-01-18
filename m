Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46566 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757443Ab2ARNR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 08:17:57 -0500
Received: by lahc1 with SMTP id c1so2201081lah.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2012 05:17:55 -0800 (PST)
Message-ID: <4F16C67F.60104@gmail.com> (sfid-20120118_141800_887477_CFA5C1BB)
Date: Wed, 18 Jan 2012 14:17:51 +0100
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Remove dummy STA on deauth
References: <1326795577-29650-1-git-send-email-pontus.fuchs@gmail.com>  (sfid-20120117_111950_717206_DA4AE268) <1326805473.3342.16.camel@jlt3.sipsolutions.net>
In-Reply-To: <1326805473.3342.16.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-01-17 14:04, Johannes Berg wrote:
>> If you need a smaller fix this might fit you.
>
> It doesn't fit me :-)
> Could you please make a fix that also fixes the missing
> finish_tx_sync()?

Abandoned. Superseded by this patch:

[PATCH 3.3] mac80211: fix work removal on deauth request

//Pontus
