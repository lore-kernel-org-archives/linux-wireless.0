Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34064 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbdHaPdb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 11:33:31 -0400
Received: by mail-oi0-f48.google.com with SMTP id w10so8542485oie.1
        for <linux-wireless@vger.kernel.org>; Thu, 31 Aug 2017 08:33:30 -0700 (PDT)
Subject: Re: RT2870 failure in kernel 4.12.8
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <b08798d4-21eb-6fda-3972-50bc1f4d0e9a@lwfinger.net>
 <20170831075514.GA12340@redhat.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <26ef3184-a19e-1bb7-7aa4-4e8647210763@lwfinger.net> (sfid-20170831_173333_807941_287B2BF4)
Date: Thu, 31 Aug 2017 10:33:28 -0500
MIME-Version: 1.0
In-Reply-To: <20170831075514.GA12340@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2017 02:55 AM, Stanislaw Gruszka wrote:
> I think it is the issue addressed by this 4.12 patch:
> https://marc.info/?l=linux-wireless&m=150366111408179&w=2
> 
> Patch for 4.13+ kernels is here:
> https://marc.info/?l=linux-wireless&m=150367345912061&w=2

A potential problem with this solution is that commit 41977e86c984 ("rt2x00: add 
support for MT7620") has been in the kernel since 4.12.0, but the openSUSE 
problem was reported not to occur until 4.12.8. I have asked that this patch be 
applied to the openSUSE source and a special test kernel be generated for our 
OP. I will let you know what develops. I do not have the necessary hardware to 
do the test in house.

Should the patch to wireless-drivers be annotated with a Stable reference so 
that it is added to 4.12 and 4.13?

Thanks,

Larry
