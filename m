Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbbABPrn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2015 10:47:43 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jesus Legaspy <jesus.legaspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtl8723au system lock ups, possible code regression
References: <CAMUBipdVDgxeTDEY=q2QP1=OyF67tvU-S1riy_CMSawj01xhgA@mail.gmail.com>
	<CAMUBipfDmww-Jv5p9ZUumfv6oto+gc9JEuez7Ee4XoEv0mGbqw@mail.gmail.com>
Date: Fri, 02 Jan 2015 10:40:48 -0500
In-Reply-To: <CAMUBipfDmww-Jv5p9ZUumfv6oto+gc9JEuez7Ee4XoEv0mGbqw@mail.gmail.com>
	(Jesus Legaspy's message of "Wed, 24 Dec 2014 03:10:09 -0600")
Message-ID: <wrfjy4plmbr3.fsf@redhat.com> (sfid-20150102_164746_816226_69180A71)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jesus Legaspy <jesus.legaspy@gmail.com> writes:
> plain text
> cc linux-wireless@vger.kernel.org
>
> On Wed, Dec 24, 2014 at 2:56 AM, Jesus Legaspy <jesus.legaspy@gmail.com> wrote:
>>
>> Hi Jes,
>>
>> I hope you're having a great Christmas celebration!
>> I've been having this issue for a while now, and decided to submit
> this bug report as many others have similar problems. Hopefully this
> helps fix the bug!
>>
>> rtl8723au driver: wifi connection drops and system lock ups,
> possible code regression
>>
>> I'm using Ubuntu 14.10 with Linux version 3.16.0-28-generic on
> Lenovo Yoga 13 using the built in rtl8723au driver from the kernel. At
> random times my internet doesn't work. I disactivate the internet and
> reactivate it to get it working again. It is usually at this time
> where most of the system hangs and freezes occur. The computer hangs
> and freezes occur at random times as well. I've used many wifi
> connections and types and they all cause the bug. The driver from
> lwfinger works flawlessly. Maybe there was some code regression? I've
> attached several log files.

Jesus,

First of all, I have never seen this happen in my usage, however I use
recent kernels (upstream, and Fedora). 3.16 is pre-historic in term of
the 8723au driver - please update and try again.

Second, please don't ever send me HTML email (multipart or not), it will
be ignored.

Jes
