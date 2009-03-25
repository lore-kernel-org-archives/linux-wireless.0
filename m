Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:4012 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZCYCmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 22:42:10 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3770497wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 19:42:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8d8077ac0903241921i561f2c31qb83bac154e49b6b4@mail.gmail.com>
References: <8d8077ac0903241921i561f2c31qb83bac154e49b6b4@mail.gmail.com>
Date: Tue, 24 Mar 2009 19:41:53 -0700
Message-ID: <43e72e890903241941i50b82916j6e96b8aeed5b6fa2@mail.gmail.com> (sfid-20090325_034214_898438_6AE45D2C)
Subject: Re: compat-wireless causing kernel panics?
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: paul.boillot@gmail.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 7:21 PM, Paul D Boillot <paul.boillot@gmail.com> wrote:
> Hi, I don't know if this is the right format/forum for this, but I'm
> having problems with compat-wireless.
>
> I've set up ubuntu 8.10 installs on two different computers, as well
> as compat-wireless and hostapd. On both computers, I would get
> seemingly random system freezes after installing these tools. The
> crashes have increased in frequency to the point that immediately
> post-log in, or during the log in process, they crash.
>
> The only common denominator, besides ubuntu 8.10, between them is
> compat-wireless/hostapd.
>
> Let me know if you need more information, or if this is in fact the
> appropriate forum for this.

There was typo in a patch submitted to wl (wireless-testing) the day
before and it caused panics for everyone too. I just forced an update.

v2.6.29-20318-g9aa4755
wireless-testing latest tag:
master-2009-03-24
This is compat-release:
master-2009-03-24

  Luis
