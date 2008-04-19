Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:64653 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755232AbYDSS0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 14:26:09 -0400
Message-ID: <480A38FA.3090300@lwfinger.net> (sfid-20080419_192613_738744_866B64B2)
Date: Sat, 19 Apr 2008 13:24:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	harvey.harrison@gmail.com, jbenc@suse.cz
Subject: Re: [patch 6/7] mac80211: michael.c use unaligned/byteorder helpers
References: <200804182059.m3IKxqcu015604@imap1.linux-foundation.org>
In-Reply-To: <200804182059.m3IKxqcu015604@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akpm@linux-foundation.org wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Rather than open-coding the get/put of little endian values, use
> get/put_unaligned and the byteorder helpers.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: Jiri Benc <jbenc@suse.cz>
> Cc: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

The set of 7 patches break my system, which is x86_64 using WPA-PSK 
TKIP. If I back out #6 and 7, then all is OK.

Does this series have any prerequisites? I'm running the current 
wireless-testing git tree.

Larry
