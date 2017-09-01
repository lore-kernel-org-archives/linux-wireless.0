Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35575 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbdIAPCS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 11:02:18 -0400
Received: by mail-oi0-f46.google.com with SMTP id n18so4015970oig.2
        for <linux-wireless@vger.kernel.org>; Fri, 01 Sep 2017 08:02:18 -0700 (PDT)
Subject: Re: RT2870 failure in kernel 4.12.8
To: Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <b08798d4-21eb-6fda-3972-50bc1f4d0e9a@lwfinger.net>
 <20170831075514.GA12340@redhat.com>
 <26ef3184-a19e-1bb7-7aa4-4e8647210763@lwfinger.net>
 <20170901085738.GA18397@redhat.com> <87y3pymqw2.fsf@purkki.adurom.net>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <ac74a535-80f7-6211-62ca-1016302d24bd@lwfinger.net> (sfid-20170901_170222_583050_D5F019AD)
Date: Fri, 1 Sep 2017 10:02:16 -0500
MIME-Version: 1.0
In-Reply-To: <87y3pymqw2.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/2017 09:31 AM, Kalle Valo wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
>> On Thu, Aug 31, 2017 at 10:33:28AM -0500, Larry Finger wrote:
>>> Should the patch to wireless-drivers be annotated with a Stable reference so
>>> that it is added to 4.12 and 4.13?
>>
>> According to Documentation/networking/netdev-FAQ.txt networking patches
>> should not be marked cc:stable, instead a decent commit log should
>> be written describing a bugfix. Which I believe it is done for
>> this patch.
> 
> But that's for net and net-next trees, not for wireless trees. With
> wireless patches we use "Cc: stable@..." references.

I see that this patch was just pushed for 4.14. I hope it got the Stable 
annotation at that time.

Larry
