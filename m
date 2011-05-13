Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49352 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab1EMJMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 05:12:40 -0400
Received: by mail-qw0-f46.google.com with SMTP id 3so1184920qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 02:12:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305262715.4065.436.camel@localhost>
References: <13602.31426.qm@web161615.mail.bf1.yahoo.com>
	<1305262715.4065.436.camel@localhost>
Date: Fri, 13 May 2011 11:12:39 +0200
Message-ID: <BANLkTi=Wz3E3O0jn_iuduAxJj_QwjNwqww@mail.gmail.com> (sfid-20110513_111244_635547_23CF0948)
Subject: Re: Bug#596626: [gsimmons@gsimmons.org: Bug#596626: Please support
 Linksys WUSB600N v2 WiFi USB stick]
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Walter Goldens <goldenstranger@yahoo.com>, 596626@bugs.debian.org,
	Ivo van Doorn <IvDoorn@gmail.com>,
	maximilian attems <max@stro.at>,
	linux-wireless@vger.kernel.org,
	Geoff Simmons <gsimmons@gsimmons.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 6:58 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Wed, 2011-05-11 at 09:25 -0700, Walter Goldens wrote:
>> > As mentioned by Jan, the device contains a RT3572
>> > chipset.  Its entry
>> > could moved into the section for known RT35XX devices (i.e.
>> > "#ifdef
>> > CONFIG_RT2800USB_RT35XX") as an alternative.
>> >
>> > Geoff
>>
>> This has already been done: http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commitdiff;h=ce2919c9fffe2aa52f9c3e327176d03764dbf9b5
>
> That's all very well, but that isn't going to get into a stable release
> for another 3 months!  Device ID updates that don't require new
> supporting code should be sent upstream straight away (and cc'd to
> stable@kernel.org).
>
> I've cherry-picked this and the other two updates in rt2800usb that
> aren't in Linus's tree, but that doesn't help the users of other
> distributions that would benefit from them.

Well, as this moving of the USB ID to a different (now named) set of
USB IDs in the code is not going to help the users,
as rt2x00 currently does not have support for RT35xx devices yet. Some
patches have been submitted for their support,
but these haven't been accepted (and thus applied) yet.

There's a reason why the Kconfig for these devices is stating that
support for these devices is non-functional!!!

That's why it didn't make sense to send this patch upstream
immediately and sending it to stable made even less sense.

---
Gertjan
