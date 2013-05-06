Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f54.google.com ([209.85.128.54]:56649 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3EFH0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 03:26:15 -0400
Received: by mail-qe0-f54.google.com with SMTP id q19so1890348qeb.13
        for <linux-wireless@vger.kernel.org>; Mon, 06 May 2013 00:26:14 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 May 2013 10:26:14 +0300
Message-ID: <CAApCBGyGdj3mb=nPrNrXxX3d=xm-00kf6Em=Uid6v7N-kpcKfg@mail.gmail.com> (sfid-20130506_092621_986425_DD1F7AB9)
Subject: RT5390 rev 0503 problems
From: wireless newbie <wnewbie72@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Has anyone experience with Ralink RT5390 chip with revision 0503? I
have that chip on my wireless usb module (WPER-172gn). I'm able to use
only one antenna with it but it has very poor rx signal level that
way. Adding second antenna for testing purposes clearly improves rx
level but that is no option for me.

I noticed in the list that someone had same sort of problem with
rt5390 rev 1502. Problem was hardware antenna diversity that wasn't
handled properly on the driver. Driver patch was provided to fix that.
I applied those same changes for rev 0503 and that solved my rx level
problem too.

But still I'm not getting the performance that I would expect. I
compare this module to WPER-150gn that has Ralink rt3070 in it. I'm
using those modules in station mode, and connect them to same AP from
same physical location. With rt3070 I can have two video streams
smoothly running over that wi-fi link. But when I switch to rt5390 I
have lots of hang ups on those video streams. Wi-fi link doesn't go
down or anything like that but the user experience is much worse than
with rt3070.

What could be the problem? Is rt5390 well supported on rt2x00 driver?
Or could it be that this revision (0503) has some changes in it that
needs further changes to driver? If anyone has any ideas of what I
should check or test, please let me know.
