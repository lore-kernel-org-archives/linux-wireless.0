Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:15990 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbZEVNq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 09:46:26 -0400
Received: by an-out-0708.google.com with SMTP id d40so3600357and.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2009 06:46:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <KK1J00$BAC7E4518757B17D1805E790669D6D1D@libero.it>
References: <KK1J00$BAC7E4518757B17D1805E790669D6D1D@libero.it>
Date: Fri, 22 May 2009 16:46:27 +0300
Message-ID: <40f31dec0905220646r4dd2fb0ag1e683ae95aab810b@mail.gmail.com>
Subject: Re: mac80211: TDMA approach feasible?
From: Nick Kossifidis <mickflemm@gmail.com>
To: ffileppo <ffileppo@libero.it>
Cc: "kalle.valo" <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/22 ffileppo <ffileppo@libero.it>:
>
>> > I was wondering if with mac80211 is now possible (and what effort is
>> > needed) to implement a TDMA approach. In particular I would like to:
>> > override 802.11 MPDU frame format, eliminate RTS/CTS exchange,
>> > eliminate automatic ACK and retransmission, eliminate virtual carrier
>> > sense (NAV), control PHY clear channel assessment and control
>> > transmission backoff.
>>
>> Most of this is usually implemented in firmware, so you need access to
>> firmware sources.
>>
>
> Hi,
> thanks for your answer.
>
> If these features are implemented in firmware, it should be possible to modify them if using for example Ath5k (which is a completely FOSS Linux driver) Right? Could you give me any directions?
>
> Talking about the TDMA implementation I was wondering if it is possible to achieve a time granularity of 1?s using commercial-of-the-shelf wifi cards (e.g. atheros ones).
>
> I would appreciate any ideas or thoughts on this matter.
>
> Thank you,
>
> Francesco
>

Check out freebsd they have TDMA support for the ath driver as far as
i know. It would be cool if we could port it on linux ;-)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
