Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55594 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab2BAIRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 03:17:38 -0500
Received: by pbdu11 with SMTP id u11so880611pbd.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 00:17:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UOxOio_yp4chFkcUQ_g2RkOouddViRajZjERvHSkhjUw@mail.gmail.com>
References: <1327600856-29635-1-git-send-email-linville@tuxdriver.com> <CAB=NE6UOxOio_yp4chFkcUQ_g2RkOouddViRajZjERvHSkhjUw@mail.gmail.com>
From: Alfonso Fiore <alfonso.fiore@gmail.com>
Date: Wed, 1 Feb 2012 09:17:08 +0100
Message-ID: <CAO=xpBHCcEzFwbM4L90Br2aR=-s53UP7MVAwq9fts7dPeNaydw@mail.gmail.com> (sfid-20120201_091742_139655_2014050E)
Subject: Re: [PATCH] compat: use kconfig.h in compat-2.6.h for 3.1 and later kernels
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 1, 2012 at 8:10 AM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Thu, Jan 26, 2012 at 10:00 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> This file was introduced in commit 2a11c8ea20bf850b3a2c60db8c2e7497d28aba99
>> and included in 3.1 and later kernels.  It includes <generated/autoconf.h>
>> itself, as well as some other definitions that are used elsewhere.
>>
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> Apologies for the delay, and thanks a lot, applied and pushed!

Hi,

thank you.

how can I test this? I see the bleeding edge package has not been
update during the last seven days. Will it be updated soon or should I
test with git?

cheers,
alfonso
