Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:42476 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYDHWGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 18:06:10 -0400
Received: by fg-out-1718.google.com with SMTP id l27so2063517fgb.17
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2008 15:06:08 -0700 (PDT)
Message-ID: <47FBEC4B.7030205@gmail.com> (sfid-20080408_230633_755757_4DC0DEBD)
Date: Wed, 09 Apr 2008 00:06:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 1/2] mac80211: fix recursive locking in	ieee80211_sta_expire
References: <1207598029-20000-1-git-send-email-jirislaby@gmail.com> <20080408183556.GC8183@tuxdriver.com>
In-Reply-To: <20080408183556.GC8183@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2008 08:35 PM, John W. Linville wrote:
> On Mon, Apr 07, 2008 at 09:53:48PM +0200, Jiri Slaby wrote:
>> Hi,
>>
>> it's against -mm, what's current mac80211 git tree? It seems that
>> -mm has fresher material, than wireless-2.6...
> 
> As it should.  The wireless-2.6 tree is for feeding the linux-2.6 tree
> (by way of the net-2.6 tree).  Similarly, wireless-2.6.26 feeds -mm
> by way of the net-2.6.26 tree.

Wow, too many trees even with their branches to know the ropes.

> Please use the wireless-testing tree for development, as it contains
> both sets of patches (fixes for the current release and updates for the
> future) as well as a few extras (like drivers still in development).
> Plus it is somewhat more stable, being based off the most a recent
> -rc release rather than just whatever someone last pulled.

Ok, thanks.
