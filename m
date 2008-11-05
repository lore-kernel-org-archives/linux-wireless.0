Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30835 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbYKEKVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 05:21:52 -0500
To: "Alexey Fisher" <bug-track@fisher-privat.net>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, rjw@sisk.pl, kernel-testers@vger.kernel.org
Subject: Re: [PATCH] make assocaittion only if SSID is known.
References: <1225836101-5723-1-git-send-email-bug-track@fisher-privat.net>
	<1225838828.22671.0.camel@localhost.localdomain>
	<871vxq217k.fsf@nokia.com> <1225875556.5905.11.camel@zwerg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 05 Nov 2008 12:20:28 +0200
In-Reply-To: <1225875556.5905.11.camel@zwerg> (ext Alexey Fisher's message of "Wed\, 05 Nov 2008 09\:59\:15 +0100")
Message-ID: <87skq6fp8z.fsf@nokia.com> (sfid-20081105_112200_007765_66173444)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alexey Fisher <bug-track@fisher-privat.net> writes:

> Am Mittwoch, den 05.11.2008, 07:25 +0200 schrieb Kalle Valo:
>> Dan Williams <dcbw@redhat.com> writes:
>> 
>> > On Tue, 2008-11-04 at 23:01 +0100, Alexey Fisher wrote:
>> >> 'iwconfig eth1 channel 6' would trigger association to _something_,
>> >> which is wrong. Changing the channel should (and does) trigger
>> >> reassociation, but only if there is an SSID to associate with!
>> >
>> > Heh :)  Need the Signed-off-by: here too though.
>> 
>> And the subject should contain the driver name, for example like this:
>
> I found some time to _read_ linux-2.6/Documentation/Submit* ! ;)
> but i think it need some "howto submit the patch with git". My englisch
> is to bad to make documentation. Here was my steps:
>
> $git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> $git pull
> $vi make/changes
> $git-commit -a

In this phase just write the commit log in this style:

----------------------------------------------------------------------
stlc45xx: fix bug in blah blah

stlc45xx was really broken in blah blah blah, I had
to blah blah blah.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
----------------------------------------------------------------------

git will take care of the rest.

-- 
Kalle Valo
