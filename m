Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53647 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1ICTjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Sep 2011 15:39:07 -0400
Received: by yxj19 with SMTP id 19so1776733yxj.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Sep 2011 12:39:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E6152FF.40101@lwfinger.net>
References: <CACna6rwU4RuYuiAFjXFDH-c+EFsKtKFmB1Sh8kXdb9EoUt4abg@mail.gmail.com>
	<CACna6rzkSgbf8sV2S1mg2OhxKstXeiqnmNmYFSMuAc563acBpg@mail.gmail.com>
	<CACna6ryTA+nbz9cJtFEWypb1atY2s+eKseANM-u=-EjW6FWE7Q@mail.gmail.com>
	<CACna6rzJzzhdBig48TGV=cfBYuvmjxowSw2Ai_GA-W0n_Y3Qkw@mail.gmail.com>
	<4E6152FF.40101@lwfinger.net>
Date: Sat, 3 Sep 2011 21:39:06 +0200
Message-ID: <CACna6ryDDorBuh_JJRzm05W_zWaQs+4xJTpbhHPDcXaK0F-ORw@mail.gmail.com> (sfid-20110903_213918_664361_2A8AC90C)
Subject: Re: Looking for BCM43228
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 3 września 2011 00:04 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 08/29/2011 04:27 PM, Rafał Miłecki wrote:
>>
>> W dniu 29 sierpnia 2011 21:02 użytkownik Rafał Miłecki
>> <zajec5@gmail.com>  napisał:
>>>
>>> I'll mail Marc, Ubuntu's launchpad reported to ask if he still has
>>> access to this notebook.
>>
>> I've just received photo of the card (inside notebook) from Marc. It's
>> labeled as DW1530, bingo! :)
>>
>> I'll ask Dell about prices. Larry: I'm also waiting for you getting
>> response, maybe your prices will be lower?
>
> I got no answer from that first vendor. I just sent another message to a
> different vendor. I found the device on a parts list for some government
> organization in Ohio that listed the Dell Part Number (430-3960) and a price
> of 12.15 USD. Too bad I couldn't purchase there.

It seems Dell can be the only choice for us. I've asked Marc for
checking details of that card. I asked him to try bcma&b43 or get MMIO
dump with wl. That will make us sure what's PHY hidden inside of that
card.

I've already bought once a card (BCM43225) in hope it'll contain PHY
different that card I already have (BCM43224). That cards seem to have
exactly the same PHY.

-- 
Rafał
