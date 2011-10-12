Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60888 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1JLDRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 23:17:31 -0400
Received: by iaek3 with SMTP id k3so301180iae.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 20:17:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <op.v27rusy7ya27un@edmitar>
References: <op.v27rusy7ya27un@edmitar>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 12 Oct 2011 14:17:11 +1100
Message-ID: <CAGRGNgUQycf2Z+5ixLXUMqe13wgTyk+9zGAMRRCfxCshhcLnGA@mail.gmail.com> (sfid-20111012_051734_654944_E4209522)
Subject: Re: [RFC 03/07] compat-wireless: Enable changing regulatory domain
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>,
	Johan Lilje <johan.lilje@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

Some minor comments on this patch:

Note that I'm not a maintainer and that these are comments on the
patch itself, not the code it adds.

On Wed, Oct 12, 2011 at 12:02, Dmitry Tarnyagin <abi.dmitryt@gmail.com> wrote:
> From: Johan Lilje <johan.lilje@stericsson.com>
> Date: Tue, 2 Aug 2011 09:21:49 +0200
>
> If compat-wireless code is compiled into the kernel,
> first request regulatory hint fails to return since
> userspace is not ready yet.
> Added timeout mechanism to remove old pending requests.
>
> Signed-off-by: Johan Lilje <johan.lilje@stericsson.com>
> ---
>  include/net/regulatory.h |    3 +++
>  net/wireless/reg.c       |   26 +++++++++++++++++++++++---

Again, you're updating files that aren't part of the compat-wireless
repository. Are you sure this patch is correct?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
