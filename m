Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn1bon0138.outbound.protection.outlook.com ([157.56.111.138]:49160
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751895AbaLCRAc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 12:00:32 -0500
Received: by mail-ob0-f172.google.com with SMTP id wn1so11756600obc.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2014 09:00:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547ED33C.5020409@broadcom.com>
References: <CAMkzgA5=NA-yLEWcvhXYpHmTAyqqiR7s58ndv-0gcSiZ3Ps88g@mail.gmail.com>
 <20141202003143.GA11546@tuxdriver.com> <547E1485.40302@broadcom.com> <547ED33C.5020409@broadcom.com>
From: Eric Schultz <eschultz@prplfoundation.org>
Date: Wed, 3 Dec 2014 11:00:03 -0600
Message-ID: <CAMkzgA64La8cwJcNNQ2i9GGksoWQNTcUAiva-7OW2b30eC3rCQ@mail.gmail.com> (sfid-20141203_180036_627552_506DAD3C)
Subject: Re: New FCC requirements and Linux Wifi
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend,

Thanks, that is the publication!

I've tried to summarize the topic at
http://wiki.prplfoundation.org/wiki/Complying_with_FCC_rules_on_5ghz_wifi.
I hope that provides folks with enough background to understand what's
going on and the issues with fixing it. If you think you can add
additional information to clarify anything, don't hesitate to do so.

We do most of our discussions on our list at
openwrt@lists.prplfoundation.org so feel free to join the list and
share your thoughts on this with other members of the community. I'd
like to organize an online meeting this month (or early next) of all
the interested parties to discuss suggestions on how to handle this.

Thanks,

Eric

On Wed, Dec 3, 2014 at 3:09 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 12/02/14 20:35, Arend van Spriel wrote:
>>
>> On 12/02/14 01:31, John W. Linville wrote:
>>>
>>> On Mon, Dec 01, 2014 at 04:27:25PM -0600, Eric Schultz wrote:
>>>>
>>>> All,
>>>>
>>>> I work for the prpl Foundation, an open source foundation organized by
>>>> a number of companies, most related to MIPS. One project we work with
>>>> externally is the OpenWrt project. Recently one of our members
>>>> mentioned a new FCC requirement (described in FCC publication 594280)
>>>> which requires wifi hardware devices to restrict modifications in ways
>>>> that were not previously required. Some of the suggestions the company
>>>> had internally for complying would be to use features like Secure Boot
>>>> and other types of DRM-like mechanisms to prevent routers from being
>>>> modified. This obviously would be quite bad for the OpenWrt community
>>>> (and the embedded Linux community as a whole) so we agreed as a group
>>>> to try to provide hardware companies with a way of complying without
>>>> harming the community.
>
>
> The FCC publication can be found here:
>
> https://apps.fcc.gov/oetcf/kdb/forms/FTSSearchResultPage.cfm?switch=P&id=39498
>
> I had issues downloading the guidance document itself.
>
> Another fine read from 2010 is here:
>
> http://www.fcc.gov/oet/ea/presentations/files/oct10/FCC_Roundtable_General_Discussion_101910-Staff.pdf
>
> At page 13 of this document are draft updates that Eric is probably
> referring to.
>
> Regards,
> Arend
>
>>>> I'm looking to find individuals (and other companies!) interested in
>>>> working with myself and the foundation, companies, the OpenWrt
>>>> community and eventually regulators to provide guidance to hardware
>>>> companies on how to best comply with these rules. If you're interested
>>>> in getting involved or just would like to know more, please get in
>>>> touch with me. We want to make sure that routers and related embedded
>>>> Linux hardware is hackable and we could use all the help we could get.
>>>>
>>>> Thanks and I look forward to working with you,
>>>>
>>>> Eric
>>>
>>>
>>> Eric,
>>>
>>> Obviously, I would be interested in hearing more. I suspect there
>>> are others on the list that will be interested as well...
>>
>>
>> I think so too. Just not sure what "Linux hardware is hackable" really
>> means here. Well, I guess I mean to say: tell me more. I guess with
>> hardware companies you mean OEMs here, right?
>>
>> Regards,
>> Arend
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>



-- 
Eric Schultz, Community Manager, prpl Foundation
http://www.prplfoundation.org
eschultz@prplfoundation.org
cell: 920-539-0404
skype: ericschultzwi
@EricPrpl
