Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f29.google.com ([209.85.218.29]:63183 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbZAGR2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 12:28:32 -0500
Received: by bwz10 with SMTP id 10so6288912bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 09:28:29 -0800 (PST)
Message-ID: <45e8e6c40901070928k6f885b69o19c9b7abd7af21ef@mail.gmail.com> (sfid-20090107_182835_355750_46382A3E)
Date: Wed, 7 Jan 2009 09:28:28 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH v2 3/3] libertas: if_spi, driver for libertas GSPI devices
Cc: linux-wireless@vger.kernel.org, "Colin McCabe" <colin@cozybit.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200901070938.23256.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1230951623-26998-1-git-send-email-colin@cozybit.com>
	 <1230951623-26998-3-git-send-email-colin@cozybit.com>
	 <1230951623-26998-4-git-send-email-colin@cozybit.com>
	 <200901070938.23256.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Holger.  The firmware is available for download on its own now
(please see the email I sent yesterday) and Marvell will make it
available on their website in the near future, so I don't think that
pulling it out of a driver is necessary.

On Wed, Jan 7, 2009 at 12:38 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
>> Add initial support for libertas devices using a GSPI
>> interface.  This has been tested with the 8686.  At this time,
>> as far as we know, GSPI firmware for this device is not
>> publicly distributable, but we expect this to change.
>
> Can you somewhere download a Windows CE driver that contains the
> firmware in it?  If yes, then you could use my
> firmware-extractor (with some little patches). I'm fine with
> patching support for GSPI into it if you send things in.
>
> (See "fwcutter" in this tree:)
>
> http://git.infradead.org/users/schurig/libertas-tools.git
>
