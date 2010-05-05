Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:34024 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244Ab0EEG3v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 02:29:51 -0400
Message-ID: <4BE11056.2070701@free.fr>
Date: Wed, 05 May 2010 08:29:42 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Check for channel HT capabilities in an IBSS
References: <1272955622-6987-1-git-send-email-benoit.papillault@free.fr>	 <1272955622-6987-2-git-send-email-benoit.papillault@free.fr> <1272961391.3673.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1272961391.3673.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 04/05/2010 10:23, Johannes Berg a écrit :
> On Tue, 2010-05-04 at 08:47 +0200, Benoit Papillault wrote:
>> When configuring an HT IBSS, we need to check if the specified channel
>> is capable of ht40+, ht40- or ht20.
>
> These first two patches cannot be separate.
>
> johannes
>
>

Right. Will repost a single patch including both.

Regards,
Benoit

