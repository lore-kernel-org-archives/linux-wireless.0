Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33992 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaAVVxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 16:53:33 -0500
Received: by mail-wi0-f179.google.com with SMTP id hr1so1173059wib.6
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 13:53:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390426022.4334.50.camel@jlt4.sipsolutions.net>
References: <1390373865-6088-1-git-send-email-chaitanya.mgit@gmail.com> <1390426022.4334.50.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 23 Jan 2014 03:23:11 +0530
Message-ID: <CABPxzY+Z_1PMmsUMOpSwjzv7ZLg791Ltd7VivbqAuemoYWM16A@mail.gmail.com> (sfid-20140122_225336_698923_7053C3B6)
Subject: Re: [PATCH] minstrel_ht: Use RTS_CTS when STA is in DYNAMIC SMPS mode
 for frames sent using Nss>1.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 23, 2014 at 2:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-22 at 12:27 +0530, Chaitanya T K wrote:
>
>> +             if (sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
>> +                     minstrel_mcs_groups[i].streams > 1) {
>> +                     mi->tx_flags |= IEEE80211_TX_RC_USE_RTS_CTS;
>> +             } else if (sta->smps_mode == IEEE80211_SMPS_STATIC &&
>> +                     minstrel_mcs_groups[i].streams > 1) {
>
> Your indentation is off inside the if statements. I'll have to wait for
> nbd to review the patch itself, I guess.

Ok, I will fix that. Checkpatch didn't catch that so missed it.

> PS: Your clock/timezone is wrong by approximately 10 hours.

Oh..I have sent this from my virtual-box where time is not properly set :-).
