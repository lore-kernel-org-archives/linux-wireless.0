Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49522 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2KLSOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 13:14:04 -0500
Received: by mail-qa0-f53.google.com with SMTP id k31so1713436qat.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 10:14:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <071701cdc0fe$218fc9b0$64af5d10$@com>
References: <071701cdc0fe$218fc9b0$64af5d10$@com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 12 Nov 2012 10:13:42 -0800
Message-ID: <CAG6hwVMvDL12C7n=fOvGYx-jf9F8-fGPNmU6qhhJKcuC8hpFsA@mail.gmail.com> (sfid-20121112_191408_920210_096BE2A8)
Subject: Re: Noob question: Development Environment
To: paul@foresight-mands.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Paul,

On Mon, Nov 12, 2012 at 9:49 AM, Paul Stoaks <paul@foresight-mands.com> wrote:
> Greetings.  Sorry to interrupt with a newbie question, but I need some help
> on setting up a linux wireless development and test environment.  What I
> would like to have is a stable development and test environment where I can
> work for a period of months without having to upgrade the kernel version on
> my development and test machines, but staying close to the bleeding edge
> with the core wireless modules and drivers.
>
> I have successfully built the wireless-testing tree from GIT, but have only
> discovered how to install the entire kernel produced from the build, not
> just the wireless modules.  What I would like to do is to install only the
> wireless modules, as I can do with the compat-wireless tree.  I have gotten
> compat-wireless to work for me with a lot of labor (refreshing patches), but
> I'm unsure of the correct work-flow with it.
>
> How are you folks accomplishing this?

Please see [0] and especially [1] under the section "Generating stable
releases".

Hope this does what you want.
Thomas

[0] https://backports.wiki.kernel.org/index.php/Documentation/compat-drivers
[1] https://backports.wiki.kernel.org/index.php/Documentation/compat-drivers/hacking
