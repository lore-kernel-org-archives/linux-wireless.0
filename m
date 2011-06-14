Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62198 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1FNVVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 17:21:33 -0400
Received: by iyb14 with SMTP id 14so5024028iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 14:21:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=P4B-BogYqTQ7GwFsJkpAAs5c8nQ@mail.gmail.com>
References: <1308078449.13553.14.camel@thonov-ubuntu> <BANLkTikb9NKWEaJ2-C2DYpUpp0Rm9iEkvQ@mail.gmail.com>
 <BANLkTi=P4B-BogYqTQ7GwFsJkpAAs5c8nQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 14 Jun 2011 14:21:11 -0700
Message-ID: <BANLkTimNHoUDnSQFysOPOz20_y3pKYywBw@mail.gmail.com> (sfid-20110614_232136_747396_26C6C4AC)
Subject: Re: Bad instructions on linuxwireless.org?
To: Thomas Novin <thomas@xyz.pp.se>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 14, 2011 at 1:11 PM, Thomas Novin <thomas@xyz.pp.se> wrote:
> On Tue, Jun 14, 2011 at 9:11 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>
>> Try again, a new tarball just baked.
>>
>
> That worked, the previous one was baked 2011-06-13 so why was my
> directory named 2011-06-01 instead of that? I downloaded it just 15
> minutes before sending that first email.
>
> But OK, maybe a temporary problem.

When compat-wireless cannot run ./scripts/admin-update.sh it barfs and
does not make a tarball. After I applied Hauke's new patches it was
able to run that fine and we get a tarball out.

  Luis
