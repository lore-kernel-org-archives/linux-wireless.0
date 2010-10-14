Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56348 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab0JNSET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 14:04:19 -0400
Received: by iwn35 with SMTP id 35so256744iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 11:04:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB74759.3030807@gmx.net>
References: <4CB6BE57.8010401@gmx.net> <1287071844.11341.5.camel@gnutoo-laptop>
 <AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com> <4CB74759.3030807@gmx.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 Oct 2010 11:03:57 -0700
Message-ID: <AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>
Subject: Re: Compat-wireless N900
To: George <george.news@gmx.net>
Cc: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 11:09 AM, George <george.news@gmx.net> wrote:

> I have tried using even insmod and the modules load perfectly but the wlan
> device doesn't show up.

Then that likely means you are not loading the right module.

> In dmesg nothing is displayed except for the cfg80211 and when I rmmod the
> module wl1251 (wl1251: removed or similar)
>
> I'm still wondering what the hell I have to do.

Are you sure you have the right module?

  Luis
