Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:35637 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdGQT6S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 15:58:18 -0400
Received: by mail-wr0-f172.google.com with SMTP id w4so27823603wrb.2
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 12:58:18 -0700 (PDT)
Subject: Re: BUG: brcmfmac: rework headroom check in .start_xmit() causes
 43430a1 to fail.
To: Ian Molton <ian@mnementh.co.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        davem@davemloft.net
References: <86761c42-c91d-d4a7-3ba4-314612dd7fd1@mnementh.co.uk>
 <9ad41664-804f-eaf4-de59-ad3308178362@broadcom.com>
 <9fcdf5ac-fae5-fe28-b624-9c121b8e5876@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <35261cf2-1b2f-be41-9a5f-f5fdc4ace7df@broadcom.com> (sfid-20170717_215821_692976_7F2AB0C9)
Date: Mon, 17 Jul 2017 21:58:15 +0200
MIME-Version: 1.0
In-Reply-To: <9fcdf5ac-fae5-fe28-b624-9c121b8e5876@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 17-07-17 21:56, Ian Molton wrote:
> On 17/07/17 20:14, Arend van Spriel wrote:
>>
>> On 17-07-17 21:03, Ian Molton wrote:
>>> Hi folks,
>>>
>>> I've found that:
>>>
>>> 270a6c1f65fe brcmfmac: rework headroom check in .start_xmit()
>>>
>>> Causes the 43430a1 to become non-responsive. The log starts emitting
>>> these messages:
>>
>> A fix is already pending in patchwork:
>>
>> https://patchwork.kernel.org/patch/9836383/
> 
> Confirmed, this fix does fix the breakage.

one to go...

Regards,
Arend
