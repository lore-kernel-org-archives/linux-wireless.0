Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4613 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab2FITvt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 15:51:49 -0400
Message-ID: <4FD3A936.8070600@broadcom.com> (sfid-20120609_215228_356644_0FAAE448)
Date: Sat, 9 Jun 2012 21:51:18 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, me@bobcopeland.com,
	mickflemm@gmail.com, kvalo@qca.qualcomm.com
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1339228530.4539.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339228530.4539.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/09/2012 09:55 AM, Johannes Berg wrote:
> On Fri, 2012-06-08 at 17:51 -0700, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
>>
>> Turns out that standard Linux distributions leave CONFIG_EXPERT
>> enabled. This makes this option useless for wireless testing / research
>> purposes as we don't want certain features enabled on all kernel
>> builds. This adds a new CONFIG_CFG80211_EXPERT and makes a few
>> features depend on them.
> 
> I'm not sure I see the point in CFG80211_EXPERT. All the features you're
> putting in there have nothing to do with cfg80211 at all anyway.

My understanding of this is that CFG80211_EXPERT was chosen because
cfg80211 provides the kernel side of the regulatory framework.

Gr. AvS


