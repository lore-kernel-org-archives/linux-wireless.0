Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48380 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2KLS1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 13:27:23 -0500
Received: by mail-wi0-f178.google.com with SMTP id hr7so2721309wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 10:27:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVMvDL12C7n=fOvGYx-jf9F8-fGPNmU6qhhJKcuC8hpFsA@mail.gmail.com>
References: <071701cdc0fe$218fc9b0$64af5d10$@com> <CAG6hwVMvDL12C7n=fOvGYx-jf9F8-fGPNmU6qhhJKcuC8hpFsA@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 12 Nov 2012 10:27:02 -0800
Message-ID: <CAPjQAd_BJ+fKzuRX_-vXxuDW6f9Xwu7+GXK_feQQbKZKEB8UAA@mail.gmail.com> (sfid-20121112_192726_900865_9F166697)
Subject: Re: Noob question: Development Environment
To: paul@foresight-mands.com
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Paul,

On Mon, Nov 12, 2012 at 10:13 AM, Thomas Pedersen <thomas@cozybit.com> wrote:
> Hi Paul,
>
> On Mon, Nov 12, 2012 at 9:49 AM, Paul Stoaks <paul@foresight-mands.com> wrote:
>> (...)
>> What I would like to have is a stable development and test environment where I can
>> work for a period of months without having to upgrade the kernel version on
>> my development and test machines, but staying close to the bleeding edge
>> with the core wireless modules and drivers.

Maybe running the latest kernel inside a virtual machine can be a good
solution; it all depends on the type of development you intend to do.
For instance we attach usb wireless cards to our virtualized guests to
test them with the latest kernels.  Here is a distro that we maintain
just for this type of virtualized development:
https://github.com/cozybit/distro11s

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
