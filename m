Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53252 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab1DNTbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 15:31:36 -0400
Received: by fxm17 with SMTP id 17so1395683fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 12:31:35 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Damian Lesiuk <lesiuk@gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps) MASTER MODE
Date: Thu, 14 Apr 2011 21:31:21 +0200
Cc: linux-wireless@vger.kernel.org
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com> <201104142106.48549.chunkeey@googlemail.com> <BANLkTi=HaJ0ZrtmDo=wwBOrEweZrjHqWXw@mail.gmail.com>
In-Reply-To: <BANLkTi=HaJ0ZrtmDo=wwBOrEweZrjHqWXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201104142131.21503.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 14 April 2011 21:26:42 Damian Lesiuk wrote:
> Hostapd log with -dd option.
> 
> I dont see any operation not permitted.
that's because you are looking at the wrong position... this
is logged much, much earlier @ startup.
