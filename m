Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64125 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1JOL3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 07:29:13 -0400
Received: by yxp4 with SMTP id 4so2037456yxp.5
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 04:29:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN=pzdJiBp742nrgb4eGwRDQO_nBgKNU1v405D_4SwBYPJ3S=A@mail.gmail.com>
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com>
	<CAJ-Vmomy-LGg=mh5=GqmqWuj7T8b1+oV3oaBSZpf6orJSGPTQg@mail.gmail.com>
	<CAN=pzd+8wq4Mw3Ww8jTOYNk-Q2EYOvtdgHPi=RMQqbJvJRZtdw@mail.gmail.com>
	<CAJ-VmonaBUTEKLghg8DJsqUpp6iR-R=pPuejUWwq=ukxt+utzg@mail.gmail.com>
	<CAN=pzdJiBp742nrgb4eGwRDQO_nBgKNU1v405D_4SwBYPJ3S=A@mail.gmail.com>
Date: Sat, 15 Oct 2011 19:29:12 +0800
Message-ID: <CAJ-Vmo=PFEzagWG9ddR5dYoDej7yJyHCXCVTX_67W4QNYaqihg@mail.gmail.com> (sfid-20111015_132917_764489_0878E7B9)
Subject: Re: Ath9k, single antenna on ar9280
From: Adrian Chadd <adrian@freebsd.org>
To: Stanislav Demakov <s.demakov@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 October 2011 18:02, Stanislav Demakov <s.demakov@gmail.com> wrote:
> Thanks. I'll ask him.
>
>>>both the second and third are connected to chain 1 via
> an antenna switch.
>
> That's interesting. Could you give me a clue how to implement this?
> Also after doing that, will it be enough to use only one physical
> antenna connector?

It depends on how it's all wired up. And yes, once you know how it's
wired up and which antenna configuration words to program in, you can
run just one of three antennas.



adrian
