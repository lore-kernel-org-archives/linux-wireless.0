Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45148 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1JOLda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 07:33:30 -0400
Received: by wwn22 with SMTP id 22so1768055wwn.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 04:33:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=PFEzagWG9ddR5dYoDej7yJyHCXCVTX_67W4QNYaqihg@mail.gmail.com>
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com>
	<CAJ-Vmomy-LGg=mh5=GqmqWuj7T8b1+oV3oaBSZpf6orJSGPTQg@mail.gmail.com>
	<CAN=pzd+8wq4Mw3Ww8jTOYNk-Q2EYOvtdgHPi=RMQqbJvJRZtdw@mail.gmail.com>
	<CAJ-VmonaBUTEKLghg8DJsqUpp6iR-R=pPuejUWwq=ukxt+utzg@mail.gmail.com>
	<CAN=pzdJiBp742nrgb4eGwRDQO_nBgKNU1v405D_4SwBYPJ3S=A@mail.gmail.com>
	<CAJ-Vmo=PFEzagWG9ddR5dYoDej7yJyHCXCVTX_67W4QNYaqihg@mail.gmail.com>
Date: Sat, 15 Oct 2011 15:33:08 +0400
Message-ID: <CAN=pzd+Lzj5CD7iUShDBg1HxRYiGyxCpWHeC-T6MM7NRLFT=qg@mail.gmail.com> (sfid-20111015_133332_957863_D482E6C7)
Subject: Re: Ath9k, single antenna on ar9280
From: Stanislav Demakov <s.demakov@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you tell me how exactly you did it on the AR9220 in your case, this
will be a good example at least.

2011/10/15 Adrian Chadd <adrian@freebsd.org>:
> On 15 October 2011 18:02, Stanislav Demakov <s.demakov@gmail.com> wrote:
>> Thanks. I'll ask him.
>>
>>>>both the second and third are connected to chain 1 via
>> an antenna switch.
>>
>> That's interesting. Could you give me a clue how to implement this?
>> Also after doing that, will it be enough to use only one physical
>> antenna connector?
>
> It depends on how it's all wired up. And yes, once you know how it's
> wired up and which antenna configuration words to program in, you can
> run just one of three antennas.
>
>
>
> adrian
>
