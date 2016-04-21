Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40283 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbcDUMlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 08:41:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2016-04-12
References: <1460448889.2630.12.camel@intel.com>
	<1460451541.2630.16.camel@intel.com>
Date: Thu, 21 Apr 2016 15:41:15 +0300
In-Reply-To: <1460451541.2630.16.camel@intel.com> (Emmanuel Grumbach's message
	of "Tue, 12 Apr 2016 08:59:00 +0000")
Message-ID: <87inzbcexg.fsf@kamboji.qca.qualcomm.com> (sfid-20160421_144123_927292_B07B0FD0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> On Tue, 2016-04-12 at 11:14 +0300, Emmanuel Grumbach wrote:
>> Hi Kalle,
>> 
>> I have here a pull request for 4.6. There is patch in this pull
>> request
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
>> I modified the commit message to better emphasis the need to have it
>> in
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
>> 
>> Besides this, all is fairly normal.
>> Please pull, thanks!
>> 
>> 
>> The following changes since commit
>> 7fdf9663261cc77a516396fec82cee8a8ea07e76:
>> 
>>   iwlwifi: mvm: fix memory leak in paging (2016-03-20 23:01:54 +0200)
>> 
>> are available in the git repository at:
>> 
>>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fix
>> es.git tags/iwlwifi-for-kalle-2016-04-12
>> 
>> for you to fetch changes up to
>> 2d25fb8b3a138706b63bd26ad72a95c58029954a:
>> 
>>   iwlwifi: mvm: fix accessing Null pointer during fw dump collection
>> (2016-04-12 10:03:17 +0300)
>> 
>
> Sara found an embarrassing last minute issue.
> New tag is iwlwifi-for-kalle-2016-04-12_2.

Pulled, thanks.

-- 
Kalle Valo
