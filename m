Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:36516 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaFMNtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 09:49:41 -0400
Received: by mail-oa0-f52.google.com with SMTP id j17so2870788oag.39
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2014 06:49:40 -0700 (PDT)
Message-ID: <539B0173.2070300@lwfinger.net> (sfid-20140613_154944_613366_3F389296)
Date: Fri, 13 Jun 2014 08:49:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Matt Chen <mattsled@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: Re: Driver for Mediatek MT7630E
References: <53987997.2040101@lwfinger.net> <CAGXE3d81xMB3Y4WdTBPHKCC91QaieAQd5xzAqWSgGeonbD7_vw@mail.gmail.com> <20140612124408.GB7325@redhat.com> <CALx5=V8rMz+HKE=1frLJRqCqqGMP3QPX1yJ-T+GA2dXDnohZ0g@mail.gmail.com> <5399FDFA.9000203@lwfinger.net> <20140613132545.GD2211@redhat.com>
In-Reply-To: <20140613132545.GD2211@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/13/2014 08:25 AM, Stanislaw Gruszka wrote:
> On Thu, Jun 12, 2014 at 02:22:34PM -0500, Larry Finger wrote:
>> On 06/12/2014 11:33 AM, Matt Chen wrote:
>>> If I remember correct for SLE11, that was from MediaTek-Ralink, they
>>> did it based on SLE11 kernel. The code is ouch but could work. That
>>> was a nightmare when I tried to port...can't imagine that.... :(
>>
>> I have not tested as my hardware has not been delivered, but I have
>> the driver building with current wireless-testing source. I also
>> have created a proper Makefile.
>>
>> Yes, merging the changes into rt2x00 will be a hassle.
>
> We usually we look at vendor driver and write new code to rt2x00 based
> on that. For example, I did that for RT5592, Gabor for RT3593. In
> oposite to cleaning up vendor driver in staging, it require lot of more
> work, but also guarantee that we will have clean and maintaible code.

That is what I plan on doing. This driver is already mac80211 based, thus I see 
no benefit in going to staging. You will have plenty of opportunities to review 
the code before it is submitted.

Larry


