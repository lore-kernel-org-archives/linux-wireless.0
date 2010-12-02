Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60930 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677Ab0LBXgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 18:36:12 -0500
Received: by iwn42 with SMTP id 42so1519049iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 15:36:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291331474-16475-1-git-send-email-eliad@wizery.com>
References: <1291331474-16475-1-git-send-email-eliad@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 2 Dec 2010 15:35:51 -0800
Message-ID: <AANLkTik69KDgWsHJkpAUtZY-uwAKpXLGUcrmerQbcHwM@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix pm_qos magic numbers
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 2, 2010 at 3:11 PM, Eliad Peller <eliad@wizery.com> wrote:
> the default /dev/network_latency is 2000s.
> 1900ms = 1900000us.
> just use consts.
>
> Signed-off-by: Eliad Peller <eliad@wizery.com>

I'm sorry, I don't understand what your description is saying, can you
elaborate on it some more so that when review this on the commit log
it is crystal clear what you meant?

  Luis
