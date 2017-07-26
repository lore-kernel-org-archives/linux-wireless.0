Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34797 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbdGZGgw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 02:36:52 -0400
Subject: Re: [PATCH v2 00/10] Constify attribute_group structures
To: Kalle Valo <kvalo@codeaurora.org>
References: <1499758370-24871-1-git-send-email-arvind.yadav.cs@gmail.com>
 <87fudkiskz.fsf@codeaurora.org>
Cc: sgruszka@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Message-ID: <4242536c-4888-e119-f95c-6d8a5413cdd1@gmail.com> (sfid-20170726_083710_532280_3F288649)
Date: Wed, 26 Jul 2017 12:06:09 +0530
MIME-Version: 1.0
In-Reply-To: <87fudkiskz.fsf@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,


On Tuesday 25 July 2017 06:25 PM, Kalle Valo wrote:
> Arvind Yadav <arvind.yadav.cs@gmail.com> writes:
>
>> attribute_groups are not supposed to change at runtime. So mark the
>> non-const structs as const.
>>
>> Arvind Yadav (10):
>>    [PATCH v2 01/10] net: cdc_ncm: constify attribute_group structures.
>>    [PATCH v2 02/10] net: can: at91_can: constify attribute_group structures.
>>    [PATCH v2 03/10] net: can: janz-ican3: constify attribute_group structures.
>>    [PATCH v2 04/10] wireless: ipw2200: constify attribute_group structures.
>>    [PATCH v2 05/10] wireless: ipw2100: constify attribute_group structures.
>>    [PATCH v2 06/10] wireless: iwlegacy: constify attribute_group structures.
>>    [PATCH v2 07/10] wireless: iwlegacy: Constify attribute_group structures.
>>    [PATCH v2 08/10] arcnet: com20020-pci: constify attribute_group structures.
>>    [PATCH v2 09/10] net: bonding: constify attribute_group structures.
>>    [PATCH v2 10/10] net: chelsio: cxgb3: constify attribute_group structures.
> Via which tree were you planning to push these? Is it ok if I take the
> wireless patches to my tree?
>
I have push these changes to linux-next branch. you can take this to 
your branch.

~arvind
