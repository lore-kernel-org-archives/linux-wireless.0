Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:24078 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934709AbZGQP6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 11:58:42 -0400
Received: by wf-out-1314.google.com with SMTP id 26so277791wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 08:58:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090717062907.78420@gmx.net>
References: <20090717062907.78420@gmx.net>
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Date: Fri, 17 Jul 2009 08:58:22 -0700
Message-ID: <43e72e890907170858v31f1789fu16156022d8330633@mail.gmail.com>
Subject: Re: compat-2.6 - missing usb_poison_urb on 2.6.27
To: arne.fitzenreiter@gmx.de
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 11:29 PM, <arne.fitzenreiter@gmx.de> wrote:
> Hi,
>
> i had problems to use the compat-wireless pack from yesterday (16.7.2009) because in kernel 2.6.27 the symbols usb_poison_urb and usb_unpoison_urb are missing. They should be first introduced with 2.6.28
> http://lxr.free-electrons.com/ident?v=2.6.28;i=usb_poison_urb

Hm, yeah I forgot to add the actual code and the header placement was incorrect.

> At my informations also usb_poison_anchored_urbs are also introduced with 2.6.28 so i think this is added to the wrong "compat" file
> http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat-wireless-2.6.git;a=commitdiff;h=a2c9d9009ff5692dbb517df97f328fd67940830a
> but this could be misinterpreted by me.
>
> Please check this. Thanks.

Great, thanks, will fix accordingly. Can you try new tarball?

This is a bleeding edge compat-wireless release based on: master-2009-07-10
This is compat-release: master-2009-07-08-11-g899b22b

  Luis
