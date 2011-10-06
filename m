Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42158 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab1JFUlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 16:41:49 -0400
Received: by qyk7 with SMTP id 7so3075168qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 13:41:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8E1062.1070206@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
 <201110041538.12885.chunkeey@googlemail.com> <CAB=NE6VC3txpDh4SdDKDxKWKKZVtGQXKVH8opszKDnZeeZTjUQ@mail.gmail.com>
 <201110061849.48838.chunkeey@googlemail.com> <CAB=NE6WbMi2GYJyFfvsdH-NSXn8dPBsgxgfdGXO_RHiJxwz2Fw@mail.gmail.com>
 <4E8E1062.1070206@neratec.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 6 Oct 2011 13:41:27 -0700
Message-ID: <CAB=NE6XwNDc8v-qtQuQQZdh2ST-skpcZM7wqD32qHn3CgN-5Dw@mail.gmail.com> (sfid-20111006_224152_443100_3D93B343)
Subject: Re: [ath9k-devel] [RFC 5/6] ath9k: enable DFS pulse detection
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	kgiori@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 6, 2011 at 1:32 PM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> As said above, disabling a driver's capability through a Kconfig option
> should be enough (one ifdef per driver).

OK cool.

> Since regulatory compliance and open source by principle form a
> gray-zone combination [2], testing for sure is essential to keep it more
> white than black ;)
>
> [2] http://linuxwireless.org/en/developers/Regulatory/statement#Principles

I actually do not think its grey now at all, we in fact IMHO have the
best regulatory framework out there, while still ensuring freedoms.

  Luis
