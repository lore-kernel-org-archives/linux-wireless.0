Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:33858 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbbCJOKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 10:10:07 -0400
Received: by labgq15 with SMTP id gq15so1990898lab.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2015 07:10:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54FDF901.8060808@student.ethz.ch>
References: <C768C63E9A2F584FACC2A65D915E5A2830535956@MBX13.d.ethz.ch>
	<C768C63E9A2F584FACC2A65D915E5A2830535975@MBX13.d.ethz.ch>
	<1425921599.32409.4.camel@redhat.com>
	<54FDF901.8060808@student.ethz.ch>
Date: Tue, 10 Mar 2015 16:10:06 +0200
Message-ID: <CANUX_P0mKrq_hgdkjsPVzCYfiYD6me6YTvcyRYNNYZPGtQHKeg@mail.gmail.com> (sfid-20150310_151013_304053_EAAC9965)
Subject: Re: Virtual Interfaces with iwlwifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: kilian risse <krisse@student.ethz.ch>
Cc: Dan Williams <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 9, 2015 at 9:48 PM, kilian risse <krisse@student.ethz.ch> wrote:
> I think I figured it out - I tried to create two interfaces of the same type
> station - which is not supported according to the "iw phy0 info".
>
> I use a intel 7260 card with a 3.18.7 Kernel.
> The command I used was "iw phy phy0 interface add wlan0 type station".
> Is this a limitation in hardware or software?
>

firmware which pretty much means hardware ;)
You can have BSS and P2P client though.

> Kilian
>
>
> On 03/09/2015 06:19 PM, Dan Williams wrote:
>>
>> On Mon, 2015-03-09 at 16:53 +0000, Risse Kilian wrote:
>>>
>>> Hi
>>>
>>> I tried to create a second interface and connect to another AP. But I was
>>> unable to do so. As I tried to enable the second interface I got an error:
>>> Device or resource busy. So am I right assuming that this is not possible
>>> with the iwlwifi driver?
>>
>>
>> What specific hardware do you have?
>> What kernel version do you have?
>> What specific command were you using to create the second interface?
>> What are the "software interface modes" and "valid interface
>> combinations" sections output from "iw phy0 info"?
>>
>> It's certainly possible and supported with iwlwifi, but it depends on
>> specific hardware, the driver, etc.
>>
>> Dan
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
