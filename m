Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58803 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbZKVEXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2009 23:23:04 -0500
Received: by fxm5 with SMTP id 5so3686756fxm.28
        for <linux-wireless@vger.kernel.org>; Sat, 21 Nov 2009 20:23:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <70f6a1ed0911210845s5dd46374ie74e6e105433dcae@mail.gmail.com>
References: <70f6a1ed0911210845s5dd46374ie74e6e105433dcae@mail.gmail.com>
Date: Sun, 22 Nov 2009 04:16:01 +0000
Message-ID: <3ace41890911212016x5d051f7fk7fa0db14189adf9f@mail.gmail.com>
Subject: Re: Using wireless-testing tree
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Duy Nguyen <dnlove@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 21, 2009 at 4:45 PM, Duy Nguyen <dnlove@gmail.com> wrote:

> 2) I have compat-wireless-2.6 tree in my wireless-testing tree.  I
> still don't know how to create my own compat-wireless even after going
> through the wiki online.
> cd compat-wireless-2.6
> make
> but it complains about some errors.

Updating compat-wireless is explained in one of the linuxwireless
pages: In a nutshell, do something like this: (substituting the
GIT_TREE value with your local wireless-testing checkout).

export GIT_TREE="/home/Hin-Tak/git-stuff/wireless-testing/"
./script/admin-refresh.sh

I don't know if using compat-wireless against wireless-testing kernel
works... (they should be identical). But I know it is convenient to
just build some drivers, so I hope it works.
