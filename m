Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50705 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab1GTNiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 09:38:09 -0400
Received: by fxd18 with SMTP id 18so1835252fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 06:38:07 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislav Demakov <s.demakov@gmail.com>
Subject: Re: rt2x00, AP mode, 802.11n is not working properly
Date: Wed, 20 Jul 2011 15:36:01 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAN=pzdLRaRHkg4NquUpDhEwRzq-roKQXMtMcwnr031maDSLRfw@mail.gmail.com>
In-Reply-To: <CAN=pzdLRaRHkg4NquUpDhEwRzq-roKQXMtMcwnr031maDSLRfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201107201536.01392.helmut.schaa@googlemail.com> (sfid-20110720_153813_526555_2376CA77)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 20. Juli 2011 schrieb Stanislav Demakov:
> I'm using hostapd 0.73 and 1T1R rt2x00 based wireless dongle to create
> an AP. The problem is that since version
> compat-wireless-2010-12-14.tar.bz2 802.11n mode is not working
> properly. In this driver version and all later you've broken
> something!

So, 2010-12-14 already shows the problem you've described while 2010-12-13
does not, right?

Helmut
