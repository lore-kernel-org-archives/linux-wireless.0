Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:24490 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbYATW1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 17:27:24 -0500
Received: by py-out-1112.google.com with SMTP id u52so2578324pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jan 2008 14:27:23 -0800 (PST)
Message-ID: <43e72e890801201427ldb36d5at43744b7b86d87879@mail.gmail.com> (sfid-20080120_222731_479821_7050593E)
Date: Sun, 20 Jan 2008 17:27:22 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "jared camarata" <gkjared@gmail.com>
Subject: Re: bug in makefile
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890801200011i295dd029n270de0644780f337@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <e6493e6a0801181951l2b57af9ar694dab8774838449@mail.gmail.com>
	 <43e72e890801200011i295dd029n270de0644780f337@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 20, 2008 3:11 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Jan 18, 2008 10:51 PM, jared camarata <gkjared@gmail.com> wrote:
> > There is a problem in the make file of compat-wireless on ubuntu.
> > $(PWD) is defined at '/' instead of /my/current/location/
> > It's causing this error: Makefile:19: /config.mk: No such file or  directory.
> > When i use it as a user (none-sudo), it finds the file just fine.
> > The line is include $(PWD)/$(COMPAT_CONFIG)
>
> Thanks, yes I am aware of this and am trying to work on a solution.

Solution found, committed and push out, please try new tarball.

  Luis
