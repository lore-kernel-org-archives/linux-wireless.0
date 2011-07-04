Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:43653 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1GDVmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 17:42:17 -0400
Received: by fxd18 with SMTP id 18so5570140fxd.11
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 14:42:16 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alex <alex9434@gmail.com>
Subject: Re: carl9170: Problems setting up Virtual Interface
Date: Mon, 4 Jul 2011 23:42:05 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAMJnVwmtNBrAbaL5TU-pQO+cvFn=UJC2rQroJeYASL3zJEesaw@mail.gmail.com> <201107042306.47963.chunkeey@googlemail.com> <CAMJnVwnGKH7CtxuwnTTjp+747cwLpNtp=u8VE2QAahGY9Q813Q@mail.gmail.com>
In-Reply-To: <CAMJnVwnGKH7CtxuwnTTjp+747cwLpNtp=u8VE2QAahGY9Q813Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107042342.05524.chunkeey@googlemail.com> (sfid-20110704_234220_918083_68B4084D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, July 04, 2011 11:23:04 PM Alex wrote:
> # iw dev wlan0 interface add wlan1 type station
> # iw dev wlan1-wlan0 connect AlexBox
> command failed: Network is down (-100)
Just start/up the interface and try again...
this can be done by ip link or ifconfig.

However, iw connect only works with unencrypted or WEP
networks. Getting it to work with wpa_supplicant is
more tricky since you'll have to disable scanning
completely.

Regards,
	Chr
