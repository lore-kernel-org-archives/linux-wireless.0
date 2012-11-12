Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vmail02-lax.tokbox.com ([72.51.46.97]:47902 "EHLO
	ns.stoaks-software.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab2KLSpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 13:45:05 -0500
Reply-To: <paul@foresight-mands.com>
From: "Paul Stoaks" <paul@foresight-mands.com>
To: "'Javier Cardona'" <javier@cozybit.com>
Cc: <linux-wireless@vger.kernel.org>,
	"'Thomas Pedersen'" <thomas@cozybit.com>
References: <071701cdc0fe$218fc9b0$64af5d10$@com> <CAG6hwVMvDL12C7n=fOvGYx-jf9F8-fGPNmU6qhhJKcuC8hpFsA@mail.gmail.com> <CAPjQAd_BJ+fKzuRX_-vXxuDW6f9Xwu7+GXK_feQQbKZKEB8UAA@mail.gmail.com>
In-Reply-To: <CAPjQAd_BJ+fKzuRX_-vXxuDW6f9Xwu7+GXK_feQQbKZKEB8UAA@mail.gmail.com>
Subject: RE: Noob question: Development Environment
Date: Mon, 12 Nov 2012 10:44:17 -0800
Message-ID: <074001cdc105$b8e476b0$2aad6410$@com> (sfid-20121112_194509_709773_13F9D962)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Javier,

I think that's a fantastic approach, and I have successfully built
distro11s, but I was hoping for something a little less exotic using
equipment I had on hand to start with.  My journey over this last week has
been very educational but I was left with lots of holes in my understanding,
hence my question.

I have some USB devices on order and will likely switch over to the VM
approach before long.  (Although I may take a detour into simulation for a
bit.)

Thanks, Thomas for your pointer to the compat-drivers pages.  I had been to
the old one, but there looks to be some info here that I had missed.

So much to learn, so little time!
Paul


-----Original Message-----
From: Javier Cardona [mailto:javier@cozybit.com] 
Sent: Monday, November 12, 2012 10:27 AM
To: paul@foresight-mands.com
Cc: linux-wireless@vger.kernel.org; Thomas Pedersen
Subject: Re: Noob question: Development Environment

Hi Paul,

On Mon, Nov 12, 2012 at 10:13 AM, Thomas Pedersen <thomas@cozybit.com>
wrote:
> Hi Paul,
>
> On Mon, Nov 12, 2012 at 9:49 AM, Paul Stoaks <paul@foresight-mands.com>
wrote:
>> (...)
>> What I would like to have is a stable development and test 
>> environment where I can work for a period of months without having to 
>> upgrade the kernel version on my development and test machines, but 
>> staying close to the bleeding edge with the core wireless modules and
drivers.

Maybe running the latest kernel inside a virtual machine can be a good
solution; it all depends on the type of development you intend to do.
For instance we attach usb wireless cards to our virtualized guests to test
them with the latest kernels.  Here is a distro that we maintain just for
this type of virtualized development:
https://github.com/cozybit/distro11s

Cheers,

Javier

--
Javier Cardona
cozybit Inc.
http://www.cozybit.com

