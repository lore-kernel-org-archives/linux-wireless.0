Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56342 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2ITXro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 19:47:44 -0400
Received: by wibhr14 with SMTP id hr14so1338788wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2012 16:47:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120808230200.GC6767@ritirata.org>
References: <4FD56DCA.1080200@codigosur.org> <CAJ-VmomzoXV8YBdiS_2nkzVagBupX3Be-Dmboxotwy9s3h3r7w@mail.gmail.com>
 <CAHD-aqKWdUBGyadCnVoSbkf4BysoSuvBBHrupXx-JbowqqNZPQ@mail.gmail.com>
 <CAHD-aqJrKfL8OL97wcnaaTYFZrx2cBXvdY5vKeK67u_-VjGOKg@mail.gmail.com>
 <20474.20627.928963.262924@gargle.gargle.HOWL> <4FFF2B15.5070502@codigosur.org>
 <20482.22437.126251.847921@gargle.gargle.HOWL> <20120808230200.GC6767@ritirata.org>
From: Gui Iribarren <gui@altermundi.net>
Date: Thu, 20 Sep 2012 20:47:22 -0300
Message-ID: <CAHD-aqJfM8SupT8_8JVB5YSwVp28OFkxvqOGLzSkEe3zAQ62vw@mail.gmail.com> (sfid-20120921_014748_895855_8EA77B6F)
Subject: Re: [ath9k-devel] ath9k_htc 1mbps in IBSS mode
To: pedro.st.antonio@gmail.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pedro and everyone,
Sorry for the thread necromancy, just to close this as 'solved':

On Wed, Sep 19, 2012 at 11:12 AM, Pedro Antonio
<pedro.st.antonio@gmail.com> wrote:
> Dear Guido,
>
> Do you have any progress regarding your problem that you described on
> http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg08934.html?

Here are the two resulting original patches against compat-wireless of
that time.
http://comments.gmane.org/gmane.linux.drivers.ath9k.devel/9540
https://patchwork.kernel.org/patch/1309961/

They have already been merged upstream since then,
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=e687f61eedab8895e5669cb82cebe0253631cd8c
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=6957802944ec8244cdcfbf50ffbfccf8eceaa413

so any current compat-wireless doesn't exhibit the issue (since
2012-08-21). Thanks Antonio!

in openwrt in particular, it's fixed since (at least, maybe earlier
than) r33331, a rev that updated compat-wireless package.


> I am having the same issue: in one direction I have 54Mbps and on the other
> I get just 1Mbps.
>
> I need to solve it. If you can give me a lead, I would appreciate a lot.
>
> Thanks in advanced for your time.
>
> Pedro Antonio
>

Hope that helps Pedro and others,

Cheers!

Gui
