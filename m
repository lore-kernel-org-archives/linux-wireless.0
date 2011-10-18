Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61139 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1JRJNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 05:13:24 -0400
Received: by wyg36 with SMTP id 36so352378wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 02:13:23 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9s_Garc=EDa_Saavedra?=
	<andres.garcia.saavedra@gmail.com>
Date: Tue, 18 Oct 2011 11:13:03 +0200
Message-ID: <CADxqDgEvsObWbnPTViPF5g_TOS2WRJoJK4OnEzehbdQwwgzNDQ@mail.gmail.com> (sfid-20111018_111328_123593_A097915E)
Subject: wl1251 and NoA protocol
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I would like to test Notice of Absence powersaving protocol for
802.11abg WLANs on some current android smartphone. My question is
regarding the wl1251 driver implementation for TI chipsets:

* Does the chipset/current implementation support sleep/awake
triggers? (or at least quiet elements?) -> This means, can I command
the NIC to stay quiet (slept) for certain duration of time?

My plan is to implement/test a Notice of Absence protocol where the
driver would trigger absent (quiet/sleep) periods according to the
beacon's NoA IE. Ive seen in the code the wl1251_ps_elp_sleep/wakeup
functions that might be reused for this purpose (?)

* Last (lazy) question. AFAIK only the google dev 1 phone uses this
chipset. Is there any 1ghz android device that could benefit of this
driver?


Thanks for your answer,
Andrés
