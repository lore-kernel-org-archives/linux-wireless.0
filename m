Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:50786 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097AbZJNOfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 10:35:30 -0400
Received: by iwn10 with SMTP id 10so3374499iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 07:34:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910141131.47500.kunal.gangakhedkar@gmail.com>
References: <43e72e890910131542k376a87c5rc30feb6491a06867@mail.gmail.com>
	<4AD51A7C.9060207@canonical.com> <43e72e890910131750s4d2cdb20o76d721087d9b3aaf@mail.gmail.com>
	<200910141131.47500.kunal.gangakhedkar@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 14 Oct 2009 07:34:32 -0700
Message-ID: <43e72e890910140734j196a06f2y8905d3eb1ba1abc8@mail.gmail.com>
Subject: Re: Stable compat-wireless 2.6.32-rc4 released
To: Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>
Cc: tim.gardner@canonical.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 13, 2009 at 11:01 PM, Kunal Gangakhedkar
<kunal.gangakhedkar@gmail.com> wrote:
> On Wednesday 14 Oct 2009 6:20:33 am Luis R. Rodriguez wrote:
>> On Tue, Oct 13, 2009 at 5:25 PM, Tim Gardner <tim.gardner@canonical.com>
> wrote:
>> > Speaking as a distro, what advantage does the stable wireless backport
>> > offer for the currently released kernel if we are already consumers of
>> > stable updates?
>>
>> Well if you are a distro stuck on the 2.6.31 kernel the stable
>> compat-wireless-2.6.32 gets you 2.6.32 wireless bits on 2.6.31 and
>> that means any features/drivers/large fixes/enhancements that didn't
>> make it to 2.6.31.
>>
>
> Isn't this the whole purpose of linux-backports-modules in ubuntu as well?

Yes, but lbm currently relies on the bleeding edge compat-wireless
which is exactly that -- bleeding edge, it may or may not work. The
stable compat-wireless releases are based on the latest stable kernel
releases and latest rc kernel release so they are deemed to be stable
snapshots following the kernel release cycle.

  Luis
