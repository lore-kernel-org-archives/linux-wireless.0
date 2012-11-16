Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2038 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab2KPTHo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 14:07:44 -0500
Message-ID: <50A68EB6.8090403@broadcom.com> (sfid-20121116_200747_868755_9E7E4FE6)
Date: Fri, 16 Nov 2012 20:06:30 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes.berg@intel.com>
Subject: Re: [PATCH] lib80211: hide Kconfig symbol
References: <1353020780-5459-1-git-send-email-johannes@sipsolutions.net>
 <20121116185721.GC29426@tuxdriver.com>
In-Reply-To: <20121116185721.GC29426@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2012 07:57 PM, John W. Linville wrote:
> On Fri, Nov 16, 2012 at 12:06:20AM +0100, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> There's no need to ask the user about lib80211
>> since it will be selected by drivers requiring
>> it, hide it from Kconfig.
>>
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>
> ACK -- I'll merge it...sorry that we still have to deal with this eyesore!
>

Now that it is hidden, it does not hurt so much :-) At least it does not 
give you "eyeball cancer" (my favorite quote when going down memory lane).

Gr. AvS

