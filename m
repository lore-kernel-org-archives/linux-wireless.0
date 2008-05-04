Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:11601 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202AbYEDTvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 15:51:08 -0400
Message-ID: <481E11B5.4070100@ntlworld.com> (sfid-20080504_215033_665356_907D55E0)
Date: Sun, 04 May 2008 20:42:45 +0100
From: ael <law_ence.dev@ntlworld.com>
Reply-To: law_ence.dev@ntlworld.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: iw: NL80211_IFTYPE_MESH_POINT not defined
References: <fvksqp$blq$1@ger.gmane.org>	 (sfid-20080504_194934_131530_1EA0F365) <1209923734.3655.4.camel@johannes.berg>
In-Reply-To: <1209923734.3655.4.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> interface.c: In function 'get_if_type':
>> interface.c:50: error: 'NL80211_IFTYPE_MESH_POINT' undeclared (first use
>> in this function)
>>
>> I guess that this should be defined in /usr/include/linux/nl80211.h but
>> it is not present there nor in nl80211.h in kernel 2.6.25.1 which I have
>> installed.
> 
> You'll need the header from the wireless-testing git tree, if you really
> want iw.
> 
>> I am just trying to get a usb-wifi device running with 2.6.25.x where
>> the driver has moved to mac80211. iwconfig appears to work no longer and
>> I found documentation to the effect that iw was required instead. Hence
>> my attempts to compile it.
> 
> iwconfig will definitely work, in fact, iw right now has totally
> orthogonal functionality.

Thanks very much for the reply. I conclude then that the problems that I
am having are more likely to be with the driver (zd1211rw) or some
configuration that needs changing to match the new version. I will
investigate further and probably report to the zd1211 list if that is
really the problem.

A Lawrence
