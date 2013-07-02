Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3229 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab3GBONp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 10:13:45 -0400
Message-ID: <51D2E004.8000502@broadcom.com> (sfid-20130702_161400_768509_A66A28FF)
Date: Tue, 2 Jul 2013 16:13:24 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Ilan Peer" <ilan.peer@intel.com>, linux-wireless@vger.kernel.org,
	mcgrof@do-not-panic.com
Subject: Re: [PATCH 2/3] [RFC] cfg80211: Add Kconfig option for cellular
 BS hints
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
 <1372768095-26053-3-git-send-email-ilan.peer@intel.com>
 <51D2DBB9.4010500@broadcom.com> (sfid-20130702_155518_357097_AF2DF864)
 <1372773647.8615.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1372773647.8615.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/02/2013 04:00 PM, Johannes Berg wrote:
> On Tue, 2013-07-02 at 15:55 +0200, Arend van Spriel wrote:
>> On 07/02/2013 02:28 PM, Ilan Peer wrote:
>>> Move the regulatory cellular base station hints support under
>>> a specific configuration option and make the option depend
>>> on CFG80211_CERTIFICATION_ONUS.
>>
>> This one seems not really related to the other patches. On itself it is
>> not clear to me what itch is being scratched here. Is the aim to get rid
>> of the CERTIFICATION_ONUS dependency further along the road?
>
> No, it's really just so patch 3 can add a separate option under
> CERTIFICATION_ONUS while allowing cell base station and the new option
> to be separate.

Thanks, Johannes

Missed that.

Gr. AvS




