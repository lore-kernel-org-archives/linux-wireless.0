Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44394 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbcDUM0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 08:26:03 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: David Miller <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2016-04-12
Date: Thu, 21 Apr 2016 12:25:57 +0000
Message-ID: <87mvoncfn0.fsf@kamboji.qca.qualcomm.com> (sfid-20160421_142608_006317_E21056C5)
References: <1460448889.2630.12.camel@intel.com>
	<87oa9borxv.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87oa9borxv.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Fri, 15 Apr 2016 17:41:16 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:
>
>> I have here a pull request for 4.6. There is patch in this pull request
>> that has been sent to -next already but should really have been
>> included in the current cycle. Sorry for the mess.
>>
>> The commit appears in -next as:
>>
>> commit a0b09f13036cedfd67c9cb4b9d05138e7022723d
>> Author: Ayala Beker <ayala.beker@intel.com>
>> Date:   Wed Feb 3 15:36:52 2016 +0200
>>
>>     iwlwifi: mvm: update GSCAN capabilities
>>     
>>     Gscan capabilities were updated with new capabilities supported
>>     by the device. Update GSCAN capabilities TLV.
>>
>> I modified the commit message to better emphasis the need to have it in
>> the current release. You'll see it in this pull request as:
>>
>> commit cd49727e1a2bccc4ff008dde24c2f8430dd9e368
>> Author: Ayala Beker <ayala.beker@intel.com>
>> Date:   Wed Feb 3 15:36:52 2016 +0200
>>
>>     iwlwifi: mvm: avoid to WARN about gscan capabilities
>>     
>>     Gscan capabilities were updated with new capabilities supported
>>     by the device. Update GSCAN capabilities TLV and avoid to WARN
>>     if the firmware does not have the new capabilities.
>
> I feel uneasy having the same commit on both trees, but that might just
> me. Dave, how do you suggest to handle cases like this when we want to
> get a fix from -next to the current release -rc release?

Dave replied privately that this is ok. So I'll pull this shortly.

-- 
Kalle Valo