Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42019 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1EINcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 09:32:48 -0400
Received: by wya21 with SMTP id 21so3869912wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 06:32:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110509114601.GA27067@zenon.in.qult.net>
References: <4DC2C743.9060004@01019freenet.de>
	<BANLkTi=V2=UpZENHek37q2D43KZyeAiO-Q@mail.gmail.com>
	<20110509114601.GA27067@zenon.in.qult.net>
Date: Mon, 9 May 2011 19:02:47 +0530
Message-ID: <BANLkTikAYtW5o9rVS_WT-1XuGQVXOucjZg@mail.gmail.com> (sfid-20110509_153254_519124_57D3C2B2)
Subject: =?windows-1252?Q?Re=3A_compile=2Derror_agg=2Dtx=2Ec=3A_error=3A_implicit_declarat?=
	=?windows-1252?Q?ion_of_function_=91kfree=5Frcu=92?=
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ignacy Gawedzki <i@lri.fr>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 9, 2011 at 5:16 PM, Ignacy Gawedzki <i@lri.fr> wrote:
> On Fri, May 06, 2011 at 10:35:08AM +0530, thus spake Mohammed Shafi:
>> On Thu, May 5, 2011 at 9:20 PM, Andreas Hartmann
>> <andihartmann@01019freenet.de> wrote:
>> > Hello,
>> >
>> > since May, there is a compile error in compat-wireless (against kernel
>> > 2.6.34):
>
> I, as it appears with many others, have the same kind of trouble compiling the
> latests compat-wireless snapshots on some kernels (2.6.38 for me).
>
> Obviously the kfree_rcu machinery should go into some compat/ source file.  In
> the meantime, I personnaly reverted these changes (see attached patch) and it
> works just fine.

I blindly used your patch and now the compat-wireless is compiling for me.
thanks a lot.

with regards,
shafi

>
> --
> /* This is not a comment */
>
