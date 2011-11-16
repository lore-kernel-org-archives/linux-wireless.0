Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56995 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab1KPN6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 08:58:19 -0500
Received: by ywt32 with SMTP id 32so4806490ywt.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 05:58:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321399276-3585-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321399276-3585-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Date: Wed, 16 Nov 2011 14:58:18 +0100
Message-ID: <CAGXE3d-Q_8zXX7dHp=eK=wnK7b_AZ3M+fZNekzu50ZOpJoQ9Rw@mail.gmail.com> (sfid-20111116_145822_433011_4459ADB7)
Subject: Re: [PATCH] mac80211: Add NoAck per WMM Queue Support
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 12:21 AM, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> This patch adds support for NoAck per WMM Queue. The Unicast QoS
> Header is adapted accordingly for each outgoing frame.
> The support is turned on and off through nl80211 by extending
> the WMM TX Queue Parameters, but can be triggered separately.

Just a thought: Assuming you've configured AC_VO to use NoAck and
you've only got VO traffic going on, is minstrel still able to collect enough
statistics to do proper rate selection?

Thanks,
Helmut
