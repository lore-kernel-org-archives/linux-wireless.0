Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9459 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756857AbbLATOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 14:14:18 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ben Ami, Golan" <golan.ben.ami@intel.com>
Subject: Re: [PATCH 24/41] iwlwifi: mvm: move fw-dbg code to separate file
Date: Tue, 1 Dec 2015 19:14:10 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E90714D@hasmsx107.ger.corp.intel.com> (sfid-20151201_201422_573083_92D687F1)
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
 <1448963947-24302-24-git-send-email-emmanuel.grumbach@intel.com>
 <87r3j6gfws.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/01/2015 08:53 PM, Kalle Valo wrote:
> Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:
>
>> From: Golan Ben-Ami <golan.ben.ami@intel.com>
>>
>> The fw debug functionality is big enough to warrant
>> a separate file. Move existing related functions to the new file.
>>
>> Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> [...]
>
>>  intc-scripts/publishable-files                     | 203 ++++++
> Added by accident?
>
Indeed... Thanks for catching this...
Will re-spin...
