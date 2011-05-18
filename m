Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47938 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939Ab1ERM0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 08:26:48 -0400
Received: by iyb14 with SMTP id 14so1239916iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 05:26:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinLFGzjFOtXZe1Zk2_jLjj2ZZVCrg@mail.gmail.com>
References: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
 <1305677203-16660-2-git-send-email-zajec5@gmail.com> <BANLkTinh7VVGUtEUezk3mODqpQ9zPT022Q@mail.gmail.com>
 <BANLkTinsK3f6Wqpf7ugJKBTMtRbErTdCuw@mail.gmail.com> <BANLkTinaPMr-owT31e5hbRVKBad_u9XbUw@mail.gmail.com>
 <BANLkTinLFGzjFOtXZe1Zk2_jLjj2ZZVCrg@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 18 May 2011 22:26:28 +1000
Message-ID: <BANLkTim5UDCupu2kQtes-ZNehY1SwvharA@mail.gmail.com> (sfid-20110518_142651_923373_CA368D88)
Subject: Re: [PATCH 2/9] b43: add bus device abstraction layer
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/18 Rafa³ Mi³ecki <zajec5@gmail.com>:
> W dniu 18 maja 2011 09:21 u¿ytkownik Julian Calaby
> <julian.calaby@gmail.com> napisa³:
>> As I see it, having two sets of mostly identical  wrapper functions in
>> a file seems incorrect to me. Especially as once the abstraction is
>> complete it would technically be correct to build b43 without SSB
>> support - it's much cleaner to not compile a file than have a massive
>> #ifdef block in a common file.
>>
>> Anyway, it's only a minor thing.
>
> Massive? It's *one* ifdef for one bus type in this file.

I count massive by the amount of code within the block, not the number
of ifdefs.

>>> A one quick question:
>>> Why didn't you respond in "[RFC][PATCH] b43: add bus abstraction
>>> layer" on 2011-04-08? Or more recent "[RFC ONLY 2/5] b43: add bus
>>> device abstraction later" posted on 2011-05-09?
>>
>> While I try to read every patch that passes through the linux-wireless
>> mailing list, I only skim them, and tend to miss some details. The
>> thing that prompted this comment was the SSB comment at the start of
>> the SSB specific wrappers - something I probably didn't read the last
>> two times the patch came up on the list.
>
> OK, I ask because it's much easier to discuss such a things before you
> got 20 patches. That's why I posted very early RFC.

I know, I completely understand. This was just a small query. If it
had jumped out at me earlier, I would have commented then.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
