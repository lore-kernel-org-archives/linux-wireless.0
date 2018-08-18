Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nyet.org ([66.175.217.148]:46668 "EHLO ln.curtisfong.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbeHRHBQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 03:01:16 -0400
Subject: Re: iwlwifi: completely opaque WARN_ON(1) at
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1363. Please remove or fix it
 (TX_STATUS_FAIL_DEST_PS)
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
References: <423cffeb-fabc-78fc-c2f6-7d9e226fc051@nyet.org>
 <1522665761.3786.365.camel@coelho.fi>
From: Nye Liu <nyet@nyet.org>
Message-ID: <7992041e-b276-4310-1c7a-5882c4fab209@nyet.org> (sfid-20180818_060405_513962_4EEB940E)
Date: Fri, 17 Aug 2018 20:45:57 -0700
MIME-Version: 1.0
In-Reply-To: <1522665761.3786.365.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=199967

On 4/2/2018 3:42 AM, Luca Coelho wrote:
> Hi,
>
> Please report this as a bug in the kernel bugzilla[1] and provide the
> logs as explained in our wiki[2].
>
> [1] https://bugzilla.kernel.org/
> [2] https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging
>
> Thanks.
>
> --
> Luca.
>
> On Mon, 2018-04-02 at 02:44 -0700, Nye Liu wrote:
>> TX_STATUS_FAIL_DEST_PS
>>
>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=887045
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1733194
>>
>> Please remove or fix the WARN_ON(1) at
>> drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1363 it is filling my
>> kernel
>> logs
>>
