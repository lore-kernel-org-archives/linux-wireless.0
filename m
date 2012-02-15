Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:58631 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab2BOQqO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 11:46:14 -0500
Received: by bkcjm19 with SMTP id jm19so1395031bkc.5
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 08:45:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6W9JdLDn7FRwuT9fEQUMs7Xkn4yyJzaYshzViGmzbBNTQ@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-2-git-send-email-victorg@ti.com>
	<4F277E8D.5040809@sipsolutions.net>
	<CAK80WHbh13duicPjTEWpTpbjiCiJUu6R_ZArYce5D7wUu1PnMA@mail.gmail.com>
	<CAB=NE6W9JdLDn7FRwuT9fEQUMs7Xkn4yyJzaYshzViGmzbBNTQ@mail.gmail.com>
Date: Wed, 15 Feb 2012 18:45:27 +0200
Message-ID: <CAK80WHYAwFQx-3VLfmB9fgEDfKwxUCMtHjveWrGU7rkJH0o9BQ@mail.gmail.com> (sfid-20120215_174655_933455_E94284A2)
Subject: Re: [RFC 1/9] nl80211/cfg80211: add radar detection command/event
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

On Fri, Feb 10, 2012 at 12:02 AM, Luis R. Rodriguez
<mcgrof@frijolero.org> wrote:
> On Thu, Feb 2, 2012 at 8:06 AM, Goldenshtein, Victor <victorg@ti.com> wrote:
>> Once we start radar detection, it should continuously monitor for
>> radar until we switch from this channel. The command applies to
>> current operational channel.
>
> Please consider adding this to the documentation,  it would make this
> crystal clear.
>

Will do that.

-- 
Thanks,
Victor.
