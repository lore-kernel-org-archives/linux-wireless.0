Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46187 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab0EDVvh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 17:51:37 -0400
Received: by pva18 with SMTP id 18so138292pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 14:51:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273007509.12618.1.camel@mj>
References: <x2q43e72e891005041344gb9945d73p3d97e648fd13aa85@mail.gmail.com>
	<1273007509.12618.1.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 4 May 2010 14:51:17 -0700
Message-ID: <z2o43e72e891005041451qa4ea338bu5a20171a82f13471@mail.gmail.com>
Subject: Re: A file to print the release of loaded compat-wireless stuff
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 4, 2010 at 2:11 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Tue, 2010-05-04 at 13:44 -0700, Luis R. Rodriguez wrote:
>> It seems there is a reasonable need to find out what version of
>> compat-wireless you have running. This will be a dated thing when
>> based on linux-next but more importantly it will contain the 2.6.3x.y
>> release the release was based on for the stable releases. Any ideas of
>> what filesystem API to use for this, I was thinking maybe a simple
>> sysfs entry for the compat module. Thoughts, preferences?
>
> We could use a read-only parameter of the compat module.  Then the
> version would be in /sys/module/compat/parameters/version
>
> Module parameters are visible in sysfs even if the code is compiled into
> the kernel.

Neat trick thanks for the tip, will give that a shot.

  Luis
