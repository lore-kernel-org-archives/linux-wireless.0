Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:34753 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZDWSEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 14:04:04 -0400
Received: by fg-out-1718.google.com with SMTP id 16so41613fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 11:04:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1240508561.30082.260.camel@johannes.local>
References: <69e28c910904231036l5fb331d5u81bcbe92b7f40179@mail.gmail.com>
	<1240508561.30082.260.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 23 Apr 2009 20:03:47 +0200
Message-ID: <69e28c910904231103o2f41468dmb32a77228f001405@mail.gmail.com> (sfid-20090423_200408_847646_E242AC6A)
Subject: Re: [PATCH 3/5] iwlwifi: Fix handling of retry count of NO_ACK frames
	in iwl-{3945|agn}-rs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/23 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2009-04-23 at 19:36 +0200, G=E1bor Stefanik wrote:
>> Make PID
>
>> =A0iwl-3945-rs.c | =A0 =A07 ++++---
>> =A0iwl-agn-rs.c =A0| =A0 14 +++++++-------
>> =A02 files changed, 11 insertions(+), 10 deletions(-)
>
> Ummm.
>
> johannes
>

Make iwl-{3945|agn}-rs... that's what I meant.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
