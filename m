Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35447 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdIACG5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 22:06:57 -0400
Received: by mail-oi0-f53.google.com with SMTP id n18so7813460oig.2
        for <linux-wireless@vger.kernel.org>; Thu, 31 Aug 2017 19:06:57 -0700 (PDT)
Subject: Re: RT2870 failure in kernel 4.12.8
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <b08798d4-21eb-6fda-3972-50bc1f4d0e9a@lwfinger.net>
 <20170831075514.GA12340@redhat.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4a9136ca-3e06-a7c1-e973-287d08249faa@lwfinger.net> (sfid-20170901_040702_044639_04542754)
Date: Thu, 31 Aug 2017 21:06:55 -0500
MIME-Version: 1.0
In-Reply-To: <20170831075514.GA12340@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2017 02:55 AM, Stanislaw Gruszka wrote:
> On Wed, Aug 30, 2017 at 12:03:06PM -0500, Larry Finger wrote:
>> Stanislaw and Helmut,
>>
>> In a bug report at https://bugzilla.suse.com/show_bug.cgi?id=1055826, the OP
>> reports that his RT3572 fails to work after an upgrade from the openSUSE
>> Tumbleweed kernel 4.12.7 to 4.12.8. I checked the kernel configuration and
>> did not see any problems.
>>
>> Are you aware of anyone reporting problems with rt2800usb in 4.12.8 kernels?
> 
> I think it is the issue addressed by this 4.12 patch:
> https://marc.info/?l=linux-wireless&m=150366111408179&w=2
> 
> Patch for 4.13+ kernels is here:
> https://marc.info/?l=linux-wireless&m=150367345912061&w=2

That patch did fix the problem. Thanks for the help.

Larry
