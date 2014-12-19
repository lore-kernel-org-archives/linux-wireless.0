Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:34188 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaLSKQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 05:16:36 -0500
Message-ID: <5493FABD.9060207@broadcom.com> (sfid-20141219_111640_297460_7FCD5895)
Date: Fri, 19 Dec 2014 11:15:25 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>
Subject: Re: [RFC V2] cfg80211: Add feature flag for 4-way handshake offload
References: <1418935344-22159-1-git-send-email-arend@broadcom.com>	 <1418980707.1889.1.camel@sipsolutions.net> <5493F34A.4040500@broadcom.com>	 <5493F6E5.5060907@broadcom.com> <1418983525.1889.2.camel@sipsolutions.net>
In-Reply-To: <1418983525.1889.2.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/19/14 11:05, Johannes Berg wrote:
> On Fri, 2014-12-19 at 10:59 +0100, Arend van Spriel wrote:
>
>> Looking at this again I wonder if it would be of value to have this as
>> NL80211_EXT_FEATURES_ATTR_LEN in nl80211.h so user-space can check the
>> nla_len() against it and detect API in-compatibility. Just can not use
>> DIV_ROUND_UP() in that case. What's your opinion?
>
> Well, userspace must not check it since it should be compatible with new
> kernels ... That was kinda my original point about not liking it in the
> header to start with :)

Understood.

Thanks,
Arend

