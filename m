Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36403 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1AEIBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 03:01:00 -0500
Received: by yxt3 with SMTP id 3so5914380yxt.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 00:00:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101041936.47573.helmut.schaa@googlemail.com>
References: <AANLkTinM9oPV=CJ3iUP2=fEH=+fRP5JPMO4tHLOZzHrS@mail.gmail.com>
	<AANLkTimPmCZ3O0WKe4OH1z4+rmtUtAr2wqsrFOUCJg_Q@mail.gmail.com>
	<201101041936.47573.helmut.schaa@googlemail.com>
Date: Wed, 5 Jan 2011 02:00:59 -0600
Message-ID: <AANLkTimV8xmFdfQcyQX4OdDkggR5mCdBiuFtWsgEkBEu@mail.gmail.com>
Subject: Re: (rt61pci/hostapd) no packet activity when encryption is enabled
 and interface is bridged
From: C Anthony Risinger <anthony@extof.me>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 4, 2011 at 12:36 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Dienstag, 4. Januar 2011 schrieb C Anthony Risinger:
>> On Mon, Jan 3, 2011 at 10:30 PM, C Anthony Risinger <anthony@extof.me> wrote:
>> >
>> > problem summary: an rt61pci driven card does not seem to allow any
>> > packets to enter/exit it's bridge ONLY WHEN ENCRYPTION is enabled;
>> > without it, everything works perfectly.
>>
>> hmmmmm....
>>
>> it would seem:
>>
>> options rt61pci nohwcrypt=1
>>
>> solves the problem.  what does this mean?  do i have a bad chip?
>
> I don't think so. Might be related to [1].

i think you might have called it (did not verify)!  i built
compat-wireless 12/26/2010 and i am now able to use the hwencrypt
option.  thanks!

> [1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=fa8b4b22d543b4052602b0c86065150613ed19e8

C Anthony
