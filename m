Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45915 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381AbaJWDSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 23:18:43 -0400
Received: by mail-wg0-f46.google.com with SMTP id l18so151341wgh.29
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 20:18:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5447CF6D.3010401@mailservices.uwaterloo.ca>
References: <5447CF6D.3010401@mailservices.uwaterloo.ca>
Date: Wed, 22 Oct 2014 20:18:41 -0700
Message-ID: <CAJ-Vmo=y=dwZjBHqbsqP5cPK+jL91W-OyA7=y8tqowgSLJKAwA@mail.gmail.com> (sfid-20141023_051846_372844_C5289F16)
Subject: Re: [ath9k-devel] Block ACK without frame aggregation
From: Adrian Chadd <adrian@freebsd.org>
To: Ali Abedi <a2abedi@uwaterloo.ca>
Cc: "(ath9k-devel@lists.ath9k.org)" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't think mac80211 supports delayed-BA. :(


-adrian


On 22 October 2014 08:38, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
> Hello,
>
> I am interested to know if we can send multiple packets (non-aggregated,
> single packets) and then ask
> for a block ACK? I like to know if this functionality has been
> implemented in ath9k or if
> it is possible to achieve this with slight code modifications.
>
> What I need:
> Frame-SIFS-Frame-SIFS-Frame-SIFS-REQ Block ACK-SIFS-Block ACK
>
> Best,
> Ali
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
