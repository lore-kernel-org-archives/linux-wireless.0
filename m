Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52614 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab3EFO6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 10:58:16 -0400
Received: by mail-wi0-f182.google.com with SMTP id m6so2641621wiv.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 May 2013 07:58:14 -0700 (PDT)
Message-ID: <5187C502.10407@gmail.com> (sfid-20130506_165825_154851_3FA53302)
Date: Mon, 06 May 2013 16:58:10 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: wnewbie72@gmail.com,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RT5390 rev 0503 problems
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wireless newbie wrote:

> Has anyone experience with Ralink RT5390 chip with revision 0503? I
> have that chip on my wireless usb module (WPER-172gn). I'm able to use
> only one antenna with it but it has very poor rx signal level that
> way. Adding second antenna for testing purposes clearly improves rx
> level but that is no option for me.
> 
> I noticed in the list that someone had same sort of problem with
> rt5390 rev 1502. Problem was hardware antenna diversity that wasn't
> handled properly on the driver. Driver patch was provided to fix that.
> I applied those same changes for rev 0503 and that solved my rx level
> problem too.

is it like this ?
http://marc.info/?l=linux-wireless&m=134136097328697
