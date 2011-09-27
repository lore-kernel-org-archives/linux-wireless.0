Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62852 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1I0Jem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 05:34:42 -0400
Received: by yxl31 with SMTP id 31so5107096yxl.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 02:34:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317113699.4082.7.camel@jlt3.sipsolutions.net>
References: <1317119624-2974-1-git-send-email-stanv@altlinux.org>
	<1317109617.4082.0.camel@jlt3.sipsolutions.net>
	<CAN8FffqH=x+qWnz=YJzatbW-b3aOgoivazH6Nb5SpsGt4Q6hGg@mail.gmail.com>
	<1317110884.4082.5.camel@jlt3.sipsolutions.net>
	<CAN8FffqjeurgAvVHtMExgeAyBHRWznYBz2c043jcZgOmqw6TVg@mail.gmail.com>
	<1317113699.4082.7.camel@jlt3.sipsolutions.net>
Date: Tue, 27 Sep 2011 13:34:42 +0400
Message-ID: <CAN8FffrZuGu63oL7ZL8EjjdNqBaPDU6KHuatwrbNB0SjffvaTg@mail.gmail.com> (sfid-20110927_113448_907181_A9C928B7)
Subject: Re: [PATCH 1/1] rfkill: add module option to become inactive.
From: "Andrew V. Stepanov" <stanv@altlinux.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: davem@davemloft.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2011 at 12:54 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-09-27 at 12:46 +0400, Andrew V. Stepanov wrote:
>
>> I wan't to completely ignore events (state) of software\hardware rfkill buttons.
>
> Why would you ever want to do that? I can see that you might want to
> ignore soft buttons, but you can use urfkilld for that. Ignoring hard
> buttons is completely useless -- they will affect the device they're
> wired up to *anyway*.

No. That is not true.

Hardware rfkill button doesn't have any action to wlan\bluetooth
devices on ThinkPad x201i with "CONFIG_RFKILL is not set".
I can assume this is true for other notebooks.

>
> johannes
>
