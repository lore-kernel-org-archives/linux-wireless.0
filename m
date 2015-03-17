Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:61444 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbbCQWUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 18:20:35 -0400
Message-ID: <5508A8B1.9050604@broadcom.com> (sfid-20150317_232039_297696_93977778)
Date: Tue, 17 Mar 2015 23:20:33 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?SsO8cmdlbiBCYXVzYQ==?= <juergen.Bausa@online.de>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43340
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir> <5504B29F.8000305@gmail.com> <55056EFB.9020100@broadcom.com> <loom.20150315T213441-211@post.gmane.org> <5505F651.3060607@broadcom.com> <loom.20150317T214603-379@post.gmane.org>
In-Reply-To: <loom.20150317T214603-379@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/17/15 22:01, Jürgen Bausa wrote:
> Arend van Spriel<arend@...>  writes:
>
>>
>> On 03/15/15 21:38, Jürgen Bausa wrote:
>>>
>>> would be nice, if you could make it clear.
>>>
>>
>> Maybe you need to mount it. This is what I found [1]:
>>
>> $ sudo mount -t efivarfs none /sys/firmware/efi/efivars
>>
>
> Thanks, that worked. Now I have firmware and nvram-file and the driver seems
> to load ok. At least I have an interface wlan0.
>
> However, I am not able to connect.Network-manager just says "interface is
> being set up ..." forever. I have no idea howto debug this. In the other
> post you said that the nl80211 driver should be used instead of wext. I
> found that nl80211 is the default for network-manager. So, whats going wrong
> here?

Could you provide output of these:

$ iw dev
$ iw list
$ ifconfig -a

Regards,
Arend
