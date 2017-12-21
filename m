Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37367 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752683AbdLUKtP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 05:49:15 -0500
Subject: Re: UBSAN: Undefined behaviour in
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c:838:5
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Luca Coelho <luca@coelho.fi>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        it+linux-wireless@molgen.mpg.de
References: <75bc638e-99a8-2f3f-6260-491f8a018af6@molgen.mpg.de>
 <1513175552.4827.365.camel@intel.com> <1513621815.4827.430.camel@coelho.fi>
 <a08aa1b3-9d75-2f38-a0f0-aefe181137da@molgen.mpg.de>
 <87r2ro9xhq.fsf@purkki.adurom.net>
From: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>
Message-ID: <4e18369a-4f39-3988-2072-5c7b9490b614@molgen.mpg.de> (sfid-20171221_114936_131514_1E56F7DE)
Date: Thu, 21 Dec 2017 11:49:13 +0100
MIME-Version: 1.0
In-Reply-To: <87r2ro9xhq.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Kalle,


On 12/21/17 11:38, Kalle Valo wrote:
> Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de> writes:
> 
>>> http://pastebin.coelho.fi/7b624f474846da52.txt
>>
>> Thank you. The warning is gone now. Thank you. For the next time, it’d
>> be great to provide the output of `git format-patch -1`, which can be
>> applied with `git am`. The output of `git show` is with my knowledge
>> hard to apply.
> 
> 'patch -p1 < foo.patch' should work. Of course it omits the commit log
> but is usually enough for testing purposes.

That’s what I did in the end. And then I have to do `git commit -a` to 
get the tree in a clean state.

So `git format-patch -1` and uploading of that, for example with some 
CLI tool, for the win. ;-)


Kind regards,

Paul
