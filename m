Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55196 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab0LHRQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 12:16:31 -0500
Received: by vws16 with SMTP id 16so1211610vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 09:16:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikmZZuD1h45RkX3QE2xAQLfoZzwSecDXvojSw5=@mail.gmail.com>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com>
	<201012061714.15863.br1@einfach.org>
	<AANLkTi=+bZbsZXR2v1AUKLEEAWGLpq-uNJXQ13t-Bf+D@mail.gmail.com>
	<AANLkTi=95mO085Y1PJ3brMMpHa=QvkxSB3SUpQysvKr+@mail.gmail.com>
	<20101208165607.GE2423@tuxdriver.com>
	<AANLkTikmZZuD1h45RkX3QE2xAQLfoZzwSecDXvojSw5=@mail.gmail.com>
Date: Wed, 8 Dec 2010 12:11:01 -0500
Message-ID: <AANLkTi=5a=LBTUcjyi0je3XYNG+=xsbA_MjtDU_dZat_@mail.gmail.com>
Subject: Re: ath5k: Weird Retransmission Behaviour
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bruno Randolf <br1@einfach.org>,
	Jonathan Guerin <jonathan@guerin.id.au>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@venema.h4ckr.net>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 8, 2010 at 12:06 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Wed, Dec 8, 2010 at 11:56 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
>>> Found the patch:
>>>
>>> https://patchwork.kernel.org/patch/359722/
>>
>> Are you posting that for merging?  Or just for testing?
>
> Testing -- I only compile tested it but it seemed relevant
> to this thread.

Also, I should note that the retry limits are fixed at
minstrel initialization time; I don't know if that's the
right time to take the config parameters into account
or if it should be done later (and if later, how that fits in
with minstrel's MRR strategy).

-- 
Bob Copeland %% www.bobcopeland.com
