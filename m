Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34037 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbbIPLGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 07:06:41 -0400
Received: by wicfx3 with SMTP id fx3so67439943wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 04:06:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4410b233bfdf45dc94eba8e913962c00@SC-EXCH04.marvell.com>
References: <CAAfyv36YLsEVarY6J8H-=Vcox=ktgeCUkqurHnAXzj_UFfthYw@mail.gmail.com>
	<26c3f35fd9e74b1d80e80077c19b6717@SC-EXCH04.marvell.com>
	<CAAfyv36Xf4f33wZvKMeTomyr_T-LKKMYkpYQwWt6B83UthFr8Q@mail.gmail.com>
	<CAOiWkA92XpC8jNq1SY_CDzNEbxNL=zrdAGMHQTs=CeLoYjSU4A@mail.gmail.com>
	<4410b233bfdf45dc94eba8e913962c00@SC-EXCH04.marvell.com>
Date: Wed, 16 Sep 2015 13:06:39 +0200
Message-ID: <CAAfyv34JhB4dULMgOFQopMjWxbTjG8rcTRe-voxd_wKq2VPfBA@mail.gmail.com> (sfid-20150916_130659_949057_A68530C0)
Subject: Re: kernel log flooded with GET_CMD_NODE: cmd node not available
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Marty Faltesek <mfaltesek@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 16, 2015 at 8:40 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
>> From: Marty Faltesek [mailto:mfaltesek@google.com]
>> Sent: Friday, September 04, 2015 3:21 AM
>> To: Belisko Marek
>> Cc: Amitkumar Karwar; linux-wireless@vger.kernel.org
>> Subject: Re: kernel log flooded with GET_CMD_NODE: cmd node not
>> available
>>
>> On Mon, Aug 31, 2015 at 7:54 AM, Belisko Marek <marek.belisko@gmail.com>
>> wrote:
>> > [  182.069146] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not
>> > available [  182.076350] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free
>> > cmd node [  182.085102] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd
>> > node not available [  182.092297] mwifiex_sdio mmc0:0001:1: PREP_CMD:
>> > no free cmd node [  182.103276] mwifiex_sdio mmc0:0001:1:
>> > GET_CMD_NODE: cmd node not available [  182.110478] mwifiex_sdio
>> > mmc0:0001:1: PREP_CMD: no free cmd node [  182.121156] mwifiex_sdio
>> > mmc0:0001:1: GET_CMD_NODE: cmd node not available [  182.128360]
>> > mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node [  182.134750]
>> > mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available [
>> > 182.141927] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
>>
>> We are also seeing these messages after recently switching to more
>> recent drivers.
>
> Marty confirmed that this problem got resolved after backporting below change to his codebase.
Same here. This patch should be marked for stable also. Many thanks.
>
> http://www.spinics.net/lists/linux-wireless/msg137134.html
>
> Regards,
> Amitkumar

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
