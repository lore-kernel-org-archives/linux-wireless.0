Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4408 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbYDIADZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 20:03:25 -0400
Date: Tue, 8 Apr 2008 19:43:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 1/2] mac80211: fix recursive locking in
	ieee80211_sta_expire
Message-ID: <20080408234321.GB23670@tuxdriver.com> (sfid-20080409_010338_598479_7D2ED77E)
References: <1207598029-20000-1-git-send-email-jirislaby@gmail.com> <20080408183556.GC8183@tuxdriver.com> <47FBEC4B.7030205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47FBEC4B.7030205@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 09, 2008 at 12:06:03AM +0200, Jiri Slaby wrote:
> On 04/08/2008 08:35 PM, John W. Linville wrote:
>> On Mon, Apr 07, 2008 at 09:53:48PM +0200, Jiri Slaby wrote:
>>> Hi,
>>>
>>> it's against -mm, what's current mac80211 git tree? It seems that
>>> -mm has fresher material, than wireless-2.6...
>>
>> As it should.  The wireless-2.6 tree is for feeding the linux-2.6 tree
>> (by way of the net-2.6 tree).  Similarly, wireless-2.6.26 feeds -mm
>> by way of the net-2.6.26 tree.
>
> Wow, too many trees even with their branches to know the ropes.

Pick your poison -- previously everyone complained about the number
of branches in the tree.

FWIW, I've had far fewer complaints about tree management since
switching to the new practices.  Of course, most of that is probably
attributable to pleasing dwmw2 (more-or-less)...

John
-- 
John W. Linville
linville@tuxdriver.com
