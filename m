Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0JAVch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 17:32:37 -0400
Received: by iwn5 with SMTP id 5so4295066iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 14:32:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009282301.00027.chunkeey@googlemail.com>
References: <201009282301.00027.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 1 Oct 2010 14:32:16 -0700
Message-ID: <AANLkTi=+a01++8ZDt3D5KVrvapBrAM0AfGF=TOxxzOEe@mail.gmail.com>
Subject: Re: [PATCH] carl9170: support firmware-based rx filter
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 2:00 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> The hardware rx-filter was essentially disabled, because
> of a serve, yet unidentifiable problem with iwlagn.
> Due to these circumstances the driver and mac80211 were
> left with the job of filtering.
>
> This is very unfortunate and has proven to be expensive
> in terms of latency, memory and load.
>
> Therefore the new 1.8.8.3 firmware introduces a flexible
> filtering infrastructure which allows the driver to
> offload some of the checks (FCS & PLCP crc check,
> RA match, control frame filter, etc...) whenever possible.
>
> Note:
> This patch also includes all changes to the
> shared headers files since the inclusion.
>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

I'm sucking this into compat-wireless into linux-next-pending/

  Luis
