Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:55717 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbaHVPNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 11:13:05 -0400
Received: by mail-qc0-f169.google.com with SMTP id c9so11128093qcz.14
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 08:13:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC4781147C18@SC-VEXCH2.marvell.com>
References: <CALtMJEDfVr1UxExOsiGK4G54BHB54wLt8co_98yZpFzH7NY9VA@mail.gmail.com>
	<CBACCFA0AEB13A41977475BCF3E896FC4781147BD9@SC-VEXCH2.marvell.com>
	<CALtMJECey7bykvHp03-r1N=d774bOUyUagJqZAbZEeHwDPstew@mail.gmail.com>
	<CBACCFA0AEB13A41977475BCF3E896FC4781147C18@SC-VEXCH2.marvell.com>
Date: Fri, 22 Aug 2014 17:13:04 +0200
Message-ID: <CALtMJECdC5bJOe1mBdMaZovO57x=aCoRK+JpyUv8YnpphssjEQ@mail.gmail.com> (sfid-20140822_171309_570927_A966B0D7)
Subject: Re: mwifiex: switching from adhoc to 5GHz managed fails
From: Andreas Fenkart <afenkart@gmail.com>
To: Avinash Patil <patila@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Avinash,

2014-08-14 10:23 GMT+02:00 Avinash Patil <patila@marvell.com>:
> Hi Andreas,
>
> Please check if this diff file helps to resolve ibss issue.
that fixes the problem, will you make this a patch?

Thanks,
Andreas
