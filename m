Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3853 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab3IWUHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 16:07:39 -0400
Message-ID: <52409F7D.1020804@broadcom.com> (sfid-20130923_220804_832319_D181F551)
Date: Mon, 23 Sep 2013 22:07:25 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Fengguang Wu" <fengguang.wu@intel.com>
cc: "Hante Meuleman" <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [brcmfmac] BUG: unable to handle kernel paging request at
 ffffffff82196446
References: <20130902102327.GB14264@localhost>
 <5236CC49.7000206@broadcom.com> <20130923121402.GA12626@localhost>
In-Reply-To: <20130923121402.GA12626@localhost>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2013 02:14 PM, Fengguang Wu wrote:
> On Mon, Sep 16, 2013 at 11:15:53AM +0200, Arend van Spriel wrote:
>> On 09/02/2013 12:23 PM, Fengguang Wu wrote:
>>> Greetings,
>>>
>>> I got the below dmesg and the first bad commit is
>>
>> Hi Fengguang,
>>
>> I could not reproduce this issue. Could you retest with the attached
>> patch file applied and let me know if that fixes the problem?
>
> Yeah it fixed the problem: no more oops in 1000 kernel boot tests. Thank you!

Whoa, 1000 boots. Thank you for being so thorough :-)

Regards,
Arend


