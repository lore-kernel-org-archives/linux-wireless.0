Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46945 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1KIX6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 18:58:13 -0500
Received: by gyc15 with SMTP id 15so2300691gyc.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 15:58:13 -0800 (PST)
Message-ID: <4EBB1392.20105@lwfinger.net> (sfid-20111110_005818_358526_32ECBEDE)
Date: Wed, 09 Nov 2011 17:58:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: New wireless-testing has grown some warnings -- please fix ASAP!
References: <20111109215007.GD10712@tuxdriver.com>
In-Reply-To: <20111109215007.GD10712@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/09/2011 03:50 PM, John W. Linville wrote:
> commit befdbc51cc69c01cd412ad2429960b9c3042f97c is the current
> wireless-testing head.
>
> This iteration of wireless-testing seems to have grown some
> warnings.  Some of them come from a new __must_check annotation of
> cfg80211_inform_bss, while others are simply unused or uninitialized
> variables.  In any case, I would prefer not to see them.
>
> Please check the wireless-testing build and attempt to squash any
> warnings that can be reasonably squashed.  Those who do not do so
> will be subject to irritated sighs over IRC, drunken emails about
> my new DVD rental service, and accusations of making unwanted sexual
> advances toward me.  You've been warned.
>
> John

For the record, what compiler are you using?

Larry

