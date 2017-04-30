Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49878 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948984AbdD3Tjw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Apr 2017 15:39:52 -0400
Subject: Re: brcmfmac: don't warn user if requested nvram fails
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <09063fc2-af77-ced6-ed90-ab20e2884969@redhat.com>
 <577dc508-07ff-c74f-5c90-b6baf4e7694a@broadcom.com>
 <e6ef170b-2ec7-e364-5097-6e0daf5b8f0d@redhat.com>
 <ae29eb44-76cb-783f-6e76-81ed15c8e0dd@broadcom.com>
 <6cee092a-f8b7-f658-cd71-829f66559882@redhat.com>
 <20170427003616.GD28800@wotan.suse.de>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <3ca61682-7267-c87b-2c3e-e4c185134cba@redhat.com> (sfid-20170430_213958_258784_A7364156)
Date: Sun, 30 Apr 2017 21:39:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170427003616.GD28800@wotan.suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 27-04-17 02:36, Luis R. Rodriguez wrote:
> On Tue, Apr 11, 2017 at 10:53:57AM +0200, Hans de Goede wrote:

<snip>

>>>> Right, sorry. For the pcie device I'm looking at the
>>>> name is brcmfmac4356-pcie.txt and I would like to propose
>>>> to first check for "brcmfmac4356-<pci-subsys-vid>-<pci-subsys-pid>.txt"
>>>>
>>>>> So who is going to provide these nvram files. We can not
>>>>> maintain that as there are too many variants and they are under control
>>>>> of the OEM/ODM.
>>>>
>>>> Users / people like me who are interested in using certain
>>>> devices with Linux. The idea is to at least make it possible to
>>>> have these devices just work. E.g. I would like a user to be
>>>> able to insert a USB-stick with a live Fedora 27 and then
>>>> have everything just work on the GPD win.
>>>>
>>>> To make this happen I will submit the nvram file from the
>>>> Windows install on the GPDwin to linux-firmware as
>>>> "brcmfmac4356-<pci-subsys-vid>-<pci-subsys-pid>.txt"
>>>> and yes I've checked that there are sensible values in
>>>> the subsys ids.
>>>
>>> I suppose the "nvram file from the Windows install" than has a
>>> redistributable license?
>>
>> IANAL but I fail to see how the contents of this file is
>> anything but functional and as such not copyright-able.
> 
> We take licensing serious on linux-firmware, a IANAL is no excuse for
> being sloppy.

I don't mean to be sloppy. As I already stated I plan to make it
clear in the commit msg that there is no license info for the nvram
file and that in my non expert opinion that is not a problem.

If people disagree then we will likely need to ask an actual lawyer
for advice and see from there,

Regards,

Hans
