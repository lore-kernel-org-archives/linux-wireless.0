Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34984 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab1LKACX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 19:02:23 -0500
Received: by vbbfc26 with SMTP id fc26so3076884vbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 16:02:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323462691.3615.0.camel@jlt3.sipsolutions.net>
References: <1323427001.3622.14.camel@jlt3.sipsolutions.net>
	<CAJ-VmomHfArfn6sQhPb=k8cP_MJ-MX5rk1c1g8JgFp=1ce9adQ@mail.gmail.com>
	<1323462691.3615.0.camel@jlt3.sipsolutions.net>
Date: Sun, 11 Dec 2011 11:02:22 +1100
Message-ID: <CAJ-Vmom2MUp=1FVnqUTcFUYM75W-Ztd3FzeNm_rTEhGpnLJqJQ@mail.gmail.com> (sfid-20111211_010227_520024_C1F06FBB)
Subject: Re: ath9k: reports wrong GI/bandwidth (bug)
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 December 2011 07:31, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2011-12-10 at 06:42 +1100, Adrian Chadd wrote:
>> Can you see whether the -final- frame in an A-MPDU has the correct GI bit set?
>
> In a dozen or so cases in the original capture file, it does seem to be
> correct in those cases. Not that it helps much, we could've missed the
> last one :-)

Ok. Well, this just adds to the "only the last frame has all the
"correct" RX state" thing :)


Adrian
