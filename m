Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36929 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0IMR36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 13:29:58 -0400
Received: by ywh1 with SMTP id 1so2102161ywh.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 10:29:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <804B13F8F3D94A4AB18B9B01ACB68FA103AB02D1@EXCHSRV.fokus.fraunhofer.de>
References: <804B13F8F3D94A4AB18B9B01ACB68FA1037B5158@EXCHSRV.fokus.fraunhofer.de>
 <20100727172020.GE8293@tux> <804B13F8F3D94A4AB18B9B01ACB68FA103AB02D1@EXCHSRV.fokus.fraunhofer.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 13 Sep 2010 10:29:26 -0700
Message-ID: <AANLkTikcnHU+JFpt7o3UG0+=Py5HKVBMmpkvZNTpQ=uy@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH 4/5] mac80211: add WoW support
To: "Simsek, Burak" <burak.simsek@fokus.fraunhofer.de>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 13, 2010 at 10:11 AM, Simsek, Burak
<burak.simsek@fokus.fraunhofer.de> wrote:
> Dear Luis,
>
> we are moving your patch to the latest version whenever we have the time to
> do so... You had sent us two patch files:
>
> http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/wow-07-21.pa
> tch
> http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/iw-add-wow.p
> atch
>
>
> The first one is successfully accomplished, but we have problems with the
> second one. I am giving a summary of the errors that we get below. There are
> files and variables defined in that patch that we cannot find anywhere and
> do not know what they should do. Can you please provide us with some hints
> regarding those errors?

The first one is the biggest chunk of work, I can take care of the
second one. Can you post the first patch so I can test?

BTW, I learned that we can test WoW in the community by using Apple
boxen, Apple devices seems to always have WoW capable 802.11 Atheros
chipsets. What are you using for your testing?

  Luis
