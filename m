Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:60887 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYJDIrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 04:47:43 -0400
Received: by gxk9 with SMTP id 9so3513115gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 04 Oct 2008 01:47:42 -0700 (PDT)
Message-ID: <43e72e890810040147j6f15966awbe555b6d37135960@mail.gmail.com> (sfid-20081004_104748_321327_9FE5E33E)
Date: Sat, 4 Oct 2008 01:47:42 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Trendnet TEW-424UB now Realtek 8187B
Cc: keithl@keithl.com, linux-wireless <linux-wireless@vger.kernel.org>,
	"Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <1223109126.24551.70.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081004011510.GA10015@gate.kl-ic.com>
	 <1223109126.24551.70.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 4, 2008 at 1:32 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2008-10-03 at 18:15 -0700, Keith Lofstrom wrote:

>> I also hope that someone will make a version of the Realtek driver
>> that works properly with Network Manager, and backport it to the
>> 2.6.24 (Ubuntu 8.04 and others) kernel.  Who should I encourage?
>
> Uh, that's unlikely to happen, unless compat-old (see the Download page
> on the wiki) works on that kernel.

What Realtek driver? Just FYI rtl8187 does *not* claim the RTL8187B. See:

http://wireless.kernel.org/en/users/Drivers/rtl8187

  Luis
