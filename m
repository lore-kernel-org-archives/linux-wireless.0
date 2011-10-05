Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36302 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934365Ab1JENCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:02:37 -0400
Received: by vws1 with SMTP id 1so1249671vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 06:02:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111005062528.GA1403@ecki>
References: <CAD2nsn1+WVaLR_TR37Z6YRCFnQH1hJkSOri=nxc8Ff3pa9N8dw@mail.gmail.com>
	<20110927214245.GA1416@ecki>
	<CAD2nsn3ZwUJsFRLyjKenO6Pm3+jr9gfmAMRDQPStEcC1hN_mkw@mail.gmail.com>
	<CAJ-Vmok8FvrYtT2QwXY0NowLSogfkZYNbGLFbVR8Uzv507FrdA@mail.gmail.com>
	<CAD2nsn0Z2J4r4tN_fLjx5bbvz2bg6NVcQ8vppJbbNcgOF8pFew@mail.gmail.com>
	<CAJ-VmokcM4KmzV7Rn9PA68iEiTJiPw=ffYgNFLDAHShxD0HNAg@mail.gmail.com>
	<20111003084823.GA1521@ecki.lan>
	<CAJ-Vmo=sE4KeOp1CKAR5v+Rzm1bm0R=ZvtMvJaE_8Sjn1dOdsw@mail.gmail.com>
	<20111004181534.GA1502@ecki>
	<CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com>
	<20111005062528.GA1403@ecki>
Date: Wed, 5 Oct 2011 21:02:36 +0800
Message-ID: <CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com> (sfid-20111005_150240_727977_4168663F)
Subject: Re: ath9k: irq storm after suspend/resume
From: Adrian Chadd <adrian@freebsd.org>
To: Clemens Buchacher <drizzd@aon.at>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 October 2011 14:28, Clemens Buchacher <drizzd@aon.at> wrote:
> For the record, instead of going to full sleep, I can reproduce the
> issue with
>
>  echo devices >/sys/power/pm_test
>  echo mem >/sys/power/state
>
> but not with
>
>  echo freezer >/sys/power/pm_test
>  echo mem >/sys/power/state
>
> So it could still be a different device that's causing the issue? I
> can try unloading all kinds of modules. Or is there an option to
> suspend just one device?

Right. So its likely something (more) odd. Yes, see if that's the case
:) At this point I'm going to punt this to the power management/ACPI
people .:)

Good luck!


Adrian
