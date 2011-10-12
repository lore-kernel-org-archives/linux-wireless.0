Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39687 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab1JLDSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 23:18:07 -0400
Received: by iaek3 with SMTP id k3so301627iae.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 20:18:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <op.v27ruwj6ya27un@edmitar>
References: <op.v27ruwj6ya27un@edmitar>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 12 Oct 2011 14:17:47 +1100
Message-ID: <CAGRGNgX_47M8WzEg0HkpZ6DQGqAx75+Ma_OM7zrAGctjB6+WcA@mail.gmail.com> (sfid-20111012_051811_805649_84C3E255)
Subject: Re: [RFC 04/07] compat-wireless: p2p power save support
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

Some minor comments on this patch:

Note that I'm not a maintainer and that these are comments on the
patch itself, not the code it adds.

On Wed, Oct 12, 2011 at 12:02, Dmitry Tarnyagin <abi.dmitryt@gmail.com> wrote:
> From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> Date: Thu, 4 Aug 2011 11:42:16 +0200
>
> P2P power save support:
>  - Opportunistic Power Save
>  - Notice Of Absence
>
> Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
> ---
>  include/linux/nl80211.h    |   12 +++++
>  include/net/cfg80211.h     |   34 +++++++++++++
>  include/net/mac80211.h     |    3 +
>  net/mac80211/cfg.c         |   24 +++++++++
>  net/mac80211/ieee80211_i.h |    3 +
>  net/mac80211/mlme.c        |  114
> ++++++++++++++++++++++++++++++++++++++++++
>  net/wireless/nl80211.c     |  119
> ++++++++++++++++++++++++++++++++++++++++++++
>  net/wireless/util.c        |    9 +++

Same again.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
