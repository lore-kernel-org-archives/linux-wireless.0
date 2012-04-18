Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45213 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2DRJa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 05:30:58 -0400
Received: by wibhj6 with SMTP id hj6so483269wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 02:30:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4B048FDE-C784-4401-9FEC-16F8CC0B8D59@gmail.com>
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com>
	<4F8DC25E.9090702@broadcom.com>
	<B9AA983D-A169-497D-9C8E-BDBEF2348BB6@gmail.com>
	<4F8E0CBE.6010103@sipsolutions.net>
	<0FC1AE2B-7E32-466B-AC33-F969F4E72B98@gmail.com>
	<CANUX_P38YDFtL-KzKnFHd0+Ca29SUXoY+mGKaDUjConXaf3c9A@mail.gmail.com>
	<4B048FDE-C784-4401-9FEC-16F8CC0B8D59@gmail.com>
Date: Wed, 18 Apr 2012 12:30:57 +0300
Message-ID: <CANUX_P0FO-P6ZFow15shNpZg6Z8FAPP7AovJH=xUKPyVEMtoBw@mail.gmail.com> (sfid-20120418_113112_119092_06CE8EE8)
Subject: Re: wlan0 not present
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dominik Feser <dominik.feser@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 18, 2012 at 11:48, Dominik Feser
<dominik.feser@googlemail.com> wrote:
> Hi Emmanuel,
>
> here is the output:
> # lspci -s 02:00 -n
> 02:00.0 0280: 8086:0082 (rev 34)
>
> THX,
> Dominik
>

Ouch I also need the subdeviceid:

sudo lspci -x -s 02:00 ?
