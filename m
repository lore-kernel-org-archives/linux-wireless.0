Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52002 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab0FPBRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 21:17:53 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTik49vfTI7UHzCOGJRXdAYJN9fLmwS-xNcHeBcAu@mail.gmail.com>
References: <20100616003813.77B0E42E2C@repository3.localdomain>
	<AANLkTik49vfTI7UHzCOGJRXdAYJN9fLmwS-xNcHeBcAu@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 15 Jun 2010 18:17:32 -0700
Message-ID: <AANLkTikR8XOdDocNAyTtezjgjpctRCteg5Q-W97cHiyP@mail.gmail.com>
Subject: Re: Compat-wireless release for 2010-06-15v2 is baked
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 5:41 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Ok if you don't see any more of these daily please kick me or Haukes.
> Both of us should have access to fix pushing these out now from orbit.
> The backup in case orbit goes down is:
>
> http://wireless.kernel.org/download/compat-wireless-2.6/

Here's another idea. If I'm on vacation or whatever, those who have
access to orbit could just flip a switch and change the git URL to
point to some other git tree to be used as base. Then to aid companies
who want to set up their own repository in case they need more timely
mannered releases based on pending patches you can use this:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-user.git

This is the same setup as what we have at orbit, it mimics the user
environment at Orbit, so all you need is an account and space and to
set up a cronjob (read the README). If you find bugs/enhancement to
the scripts just post 'em too.

For those that can wait on me I guess Orbit will do :)

  Luis
