Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:38010 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3CSWIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 18:08:20 -0400
Received: by mail-wg0-f54.google.com with SMTP id fm10so825434wgb.9
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 15:08:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANMvdA_JKwdnnmHJ36GpT4ARtfda5Ybra77ted=CEmGRr-Eeqw@mail.gmail.com>
References: <CANMvdA-YEzYM5PCEC=6bwoiFFejLFYuLYPZHhJLctEUOGHBokA@mail.gmail.com>
 <CAGRGNgWyp47qYv4uHUVdJ+sVRnJxHgPc45meUqB7p4mdc3Xr6g@mail.gmail.com> <CANMvdA_JKwdnnmHJ36GpT4ARtfda5Ybra77ted=CEmGRr-Eeqw@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 20 Mar 2013 09:07:59 +1100
Message-ID: <CAGRGNgVOQqwk8QJJVk3XMLzuo-r9hhCHMz=jj+XdEga-aRRhzw@mail.gmail.com> (sfid-20130319_230824_479373_D54DB901)
Subject: Re: IW channels list question
To: Francisco Cuesta <ndarkness@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Francisco,

Firstly, don't drop the mailing list CC, I do _not_ do private support.

Secondly, don't top post.

On Tue, Mar 19, 2013 at 10:59 PM, Francisco Cuesta <ndarkness@gmail.com> wrote:
> Hi Julian,
>
> First of all thanks for replying.
>
> Concerning to the call of iw to the API in an openwrt system do you
> know if this is the same? I mean, I have tried to find some file
> called nl80211  but without succeeding.

nl80211 is an interface with the kernel, it's not a file. It's
essentially commands to control Wifi (802.11) interfaces over NetLink.

All 'iw' commands, regardless of the Linux distribution or whatever use nl80211.

> On the other hand, I'm working with openwrt and I was aware about the
> eemprom stuff, indeed, I have enabled an openwrt feature that allows
> you to force the atheros eemprom to take into account the regulatory
> domain set by the user, but event though if I set Japan I don't see an
> update on iw list channels. Is that due to the fact that my card
> doesn't support such a frequency?

That is most likely the case.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
