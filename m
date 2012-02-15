Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:46421 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753395Ab2BOQqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 11:46:35 -0500
Received: by mail-bk0-f49.google.com with SMTP id jk13so1389097bkc.8
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 08:46:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WkArbBkiT6A4eEKEo6k2EJ2SsxjoNoPHp5BDWZNR3t8g@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-8-git-send-email-victorg@ti.com>
	<4F27819A.1030200@sipsolutions.net>
	<CAK80WHZpAAG_NWcuGUK2FJ_UwOhFXraVVkugR3W5FZEHCb6Z0A@mail.gmail.com>
	<CAB=NE6WkArbBkiT6A4eEKEo6k2EJ2SsxjoNoPHp5BDWZNR3t8g@mail.gmail.com>
Date: Wed, 15 Feb 2012 18:46:27 +0200
Message-ID: <CAK80WHY0EzZH=tNMnYsFzSsnX=AK1OLyi3m2PB7bpVC153VtZg@mail.gmail.com> (sfid-20120215_174654_719395_7ABEC4B9)
Subject: Re: [RFC 7/9] nl80211/cfg80211: add DFS feature flag
From: "Goldenshtein, Victor" <victorg@ti.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 10, 2012 at 1:11 AM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> While a it, consider adding one for the requirement of sending the
> channel switch announcement within mac80211, not the driver. In that
> case, although a DFS feature may be available in the driver, DFS
> should not be enabled on the driver through nl80211 unless that
> feature gets implemented in mac80211.
>

At this point I'd prefer to stick to the original design proposal.

-- 
Thanks,
Victor.
