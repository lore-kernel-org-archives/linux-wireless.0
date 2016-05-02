Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51682 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbcEBV1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 17:27:23 -0400
Subject: Re: [PATCH] mac80211: add vht cap decode to debugfs.
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1462223956-23384-1-git-send-email-greearb@candelatech.com>
 <1462224233.5898.22.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5727C63A.7020705@candelatech.com> (sfid-20160502_232727_112551_402689E4)
Date: Mon, 2 May 2016 14:27:22 -0700
MIME-Version: 1.0
In-Reply-To: <1462224233.5898.22.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2016 02:23 PM, Johannes Berg wrote:
>
>> +			if (vhtc->cap & IEEE80211_VHT_CAP_ ## a)+		
>> 		p += scnprintf(p, sizeof(buf) + buf
>> - p, \
>> +					       "\t\t%s\n", b);	
>
> Why not use #a instead of b?
>
>> +		PFLAG(MAX_MPDU_LENGTH_3895, "MAX-MPDU-3895");
>
>
> Makes that a bit longer in the printout, but makes the code shorter.

I don't care that much either way, but it seemed nicer to customize the output.

It at least won't change the actual compiled code much...

I'll change it to be as you suggest if you want.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

