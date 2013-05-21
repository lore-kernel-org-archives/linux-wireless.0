Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:47068 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3EUCQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 May 2013 22:16:29 -0400
MIME-Version: 1.0
In-Reply-To: <519AB89E.1080001@lwfinger.net>
References: <519AB89E.1080001@lwfinger.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 20 May 2013 19:16:06 -0700
Message-ID: <CAB=NE6Vk-pjg-4zYxUTEnqm0Mh9dwLkDBHYefpSU9piM6B6gQg@mail.gmail.com> (sfid-20130521_041632_735028_D793FDEE)
Subject: Re: Build problem with current git repo
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 20, 2013 at 4:58 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Pulling from the git repo today and trying to do a 'make menuconfig' results
> in the following error:
>
> finger@larrylap:~/backports/backport> make menuconfig

The new backports project requires you to run for example:

./gentree.py ~/linux-next/ ~/build/backports-20130520

Then you cd into ~/build/backports-20130520 and build there. Try that
with linux-next next-20130520. Note that gentree.py also accepts
--git-revision but in practice for me its faster to reset a tree than
to use that which walks the tree.

  Luis
