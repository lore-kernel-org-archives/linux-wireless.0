Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:40869 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaAJTdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 14:33:42 -0500
In-Reply-To: <1389378478.12683.0.camel@jlt4.sipsolutions.net>
References: <1389371137-30282-1-git-send-email-luca@coelho.fi> <1389378478.12683.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH IW] util: parse NL80211_CMD_CHANNEL_SWITCH
From: Luca Coelho <luca@coelho.fi>
Date: Fri, 10 Jan 2014 21:33:37 +0200
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Message-ID: <2b29dff4-f549-49b7-a153-13c701b56df6@email.android.com> (sfid-20140110_203346_031180_CDF70045)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:
>On Fri, 2014-01-10 at 18:25 +0200, Luciano Coelho wrote:
>> From: Luciano Coelho <luciano.coelho@intel.com>
>> 
>> Add the NL80211_CMD_CHANNEL_SWITCH definition to the nl80211 commands
>> array so that it prints out something useful in the phy info.
>
>I'll refresh the list in util.c instead (though not immediately, need
>to
>sort out what I can already commit and what I can't ...)

Yeah, I almost added NL80211_CMD_VENDOR and stuff too, but the nl80211.h file was not updated and I didn't know your process for updating it.

I'll wait for your update. ;)

--
Luca.


