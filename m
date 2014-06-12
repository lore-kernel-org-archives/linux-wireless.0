Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:57339 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaFLQdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 12:33:44 -0400
Received: by mail-qa0-f51.google.com with SMTP id j7so733334qaq.38
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2014 09:33:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140612124408.GB7325@redhat.com>
References: <53987997.2040101@lwfinger.net>
	<CAGXE3d81xMB3Y4WdTBPHKCC91QaieAQd5xzAqWSgGeonbD7_vw@mail.gmail.com>
	<20140612124408.GB7325@redhat.com>
Date: Fri, 13 Jun 2014 00:33:43 +0800
Message-ID: <CALx5=V8rMz+HKE=1frLJRqCqqGMP3QPX1yJ-T+GA2dXDnohZ0g@mail.gmail.com> (sfid-20140612_183349_212278_D5F54691)
Subject: Re: Driver for Mediatek MT7630E
From: Matt Chen <mattsled@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If I remember correct for SLE11, that was from MediaTek-Ralink, they
did it based on SLE11 kernel. The code is ouch but could work. That
was a nightmare when I tried to port...can't imagine that.... :(

2014-06-12 20:44 GMT+08:00 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Thu, Jun 12, 2014 at 09:16:02AM +0200, Helmut Schaa wrote:
>> On Wed, Jun 11, 2014 at 5:45 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> > In a recent E-mail interchange
>> > (http://marc.info/?l=linux-wireless&m=140238255916367&w=2), I was made aware
>> > that this device is not currently being handled by any driver in the kernel,
>> > but that there was a GitHub repo at https://github.com/anthonywong/mt7630.
>> > That code modifies rt2800pci to operate the MT7630E, but it is quite
>> > outdated.
>> >
>> > As a followup, I found such a device at a reasonable price on E-bay, and
>> > ordered it. It should arrive next week. I also was able to find the firmware
>> > in an RPM for SUSE SLE11, and a license allowing redistribution. Before I
>> > start modifying rt2800pci for this new device, I want to be assured that
>> > this modification is not currently being done by anyone in the rt2x00
>> > project. There is too much to be done to duplicate effort.
>>
>> I'm not doing anything in this regard at the moment. So I'm really glad if you
>> are working on that!
>>
>> CC'ed Stanislaw even though I don't think he's doing anything regarding the
>> device you've mentioned.
>
> Nope, I'm not working on adding support for new chips to rt2x00 at
> present nor plan to work on that in the near future, though I have that
> on my TODO list :-)
>
>> > For interested readers, I have modified the GitHub code to compile using the
>> > current wireless-testing kernel source. If there is sufficient interest, I
>> > could set up a new GH repo for it as an interim measure with conditional
>> > code allowing it to build on recent kernels (3.5+).
>
>> Awesome news.
> +1
>
> Stanislaw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
