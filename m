Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965972AbbJ1OEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 10:04:21 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2015-10-25
Date: Wed, 28 Oct 2015 14:03:25 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E8B4AB2@hasmsx107.ger.corp.intel.com> (sfid-20151028_150427_871220_D3B38551)
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
 <87mvv3tb5d.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/28/2015 02:45 PM, Kalle Valo wrote:
> "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:
> 
>> Last (obviously) pull request for 4.4.
>> I came back from a long vacation and took maintenance over back from Luca.
>> Please note that you'll have to merge mac80211-next/master (or net-next)
>> before you pull from me. I created this pull request giving
>> mac80211-next/master
>> as the start point to have the correct output.
>> I hope it will still make it.
>>
>> Details in the tag.
>>
>> Thank!
>>
>> The following changes since commit e5a9f8d04660da7ef3a98260aa74c3976f9cb4cd:
>>
>>   mac80211: move station statistics into sub-structs (2015-10-21
>> 10:08:22 +0200)
>>
>> are available in the git repository at:
>>
>>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> 
> I don't see the tag name in your pull request, but I'm going to assume
> that you meant iwlwifi-next-for-kalle-2015-10-25:
> 
> https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-next.git/tag/?h=iwlwifi-next-for-kalle-2015-10-25
> 
> Please let me know ASAP if that's not the case.
> 

That's right. Sorry, I created the pull request with HEAD and not with
the tag.
