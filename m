Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42276 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab0GIW3U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 18:29:20 -0400
Received: by pzk26 with SMTP id 26so577754pzk.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jul 2010 15:29:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1278712573.9411.4.camel@mj>
References: <20100709190222.115F242E2D@repository3.orbit-lab.org>
	<1278712573.9411.4.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 9 Jul 2010 15:29:00 -0700
Message-ID: <AANLkTingMmay_a0ZpwxRi2AQ6tVMJLiBSz_bm9HZVFUn@mail.gmail.com>
Subject: Re: Compat-wireless release for 2010-07-09 is baked
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 9, 2010 at 2:56 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Fri, 2010-07-09 at 15:02 -0400, Compat-wireless cronjob account
> wrote:
>> Base tree: linux-next.git
>> Base tree version: next-20100708
>> compat-wireless release: compat-wireless-2010-07-08-1-g469f74f
>> ssh: Could not resolve hostname wireless.kernel.org: Name or service not known
>> rsync: connection unexpectedly closed (0 bytes received so far) [sender]
>> rsync error: unexplained error (code 255) at io.c(600) [sender=3.0.6]
>
> Still not good.  The 2010-07-09 release is not on the download site.  I
> assume the upload failed.

I'll take a look.

> Perhaps only successful reports should go to the list, and unsuccessful
> reports should go to those who can fix the problem?

Sure, I'll try to address this, but also feel free to send patches against:

http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat-user.git;a=summary

  Luis
