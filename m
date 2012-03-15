Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51227 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab2COKeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 06:34:14 -0400
Received: by yenl12 with SMTP id l12so2844363yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 03:34:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJwzM1=GYDoE5C4idMOHnY71HAM1O+Joc-Tw+ciWZwdGi8P3kg@mail.gmail.com>
References: <CAJwzM1=GYDoE5C4idMOHnY71HAM1O+Joc-Tw+ciWZwdGi8P3kg@mail.gmail.com>
Date: Thu, 15 Mar 2012 12:34:13 +0200
Message-ID: <CAB3XZEcysgM=u3Xj34fd7_AOuMPgkCoxSCt7NvFSDEQSrXGEuA@mail.gmail.com> (sfid-20120315_113417_788550_B71C8060)
Subject: Re: Compilation errors in module mac80211 with latest tree
From: Eliad Peller <eliad@wizery.com>
To: Avinash Patil <avinashapatil@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2012 at 11:13 AM, Avinash Patil <avinashapatil@gmail.com> wrote:
>   CC [M]  net/mac80211/cfg.o
> net/mac80211/cfg.c: In function ‘sta_apply_parameters’:
> net/mac80211/cfg.c:769: error: implicit declaration of function
> ‘sta_info_move_state_checked’
> make[1]: *** [net/mac80211/cfg.o] Error 1
>
what version is it?
it doesn't seem to exist in wireless-testing.

>
> When I searched markmail.org, it looks like Eliad Peller had removed
> all instances of sta_info_move_state_checked and replaced with
> sta_info_move_state. Has it reappeared because of some other
> check-in/or some issue with my git setup?
>
not every sent patch is getting applied.
you should do such investigations with git log/blame.

Eliad.
