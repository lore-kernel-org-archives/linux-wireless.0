Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37919 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1DOWhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 18:37:32 -0400
Received: by fxm17 with SMTP id 17so2094822fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2011 15:37:30 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Damian Lesiuk <lesiuk@gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps) MASTER MODE
Date: Sat, 16 Apr 2011 00:37:23 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
References: <BANLkTik7Sd0fB94pPjeBNJ-u5zyTVX0oiw@mail.gmail.com> <BANLkTinf6+p4kKfDyKYhuwSewwJ7dsvaqQ@mail.gmail.com> <BANLkTinN0ezj2HUJTijwfZprJrCjznf-5g@mail.gmail.com>
In-Reply-To: <BANLkTinN0ezj2HUJTijwfZprJrCjznf-5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201104160037.24248.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 April 2011 21:01:43 Damian Lesiuk wrote:
> It seems that I have a very crowded band. But, 6 MB / s is for me
> entirely sufficient.
> 
come to think of it, there is a way to get a more throughput and
stability by disabling the flakey hw crypto engine.
This can be done by setting nohwcrypt=1 [module parameter].

Furthermore, you could get a MIMO replacement for your client's
cost-reduced SISO ar9285 card. This way, ar9170 [or future devices]
are not limited to use only a single stream/chain [MCS0-7].

<http://linuxwireless.org/en/developers/Documentation/ieee80211/802.11n#MCS_Rates>

Regards,
	Chr
