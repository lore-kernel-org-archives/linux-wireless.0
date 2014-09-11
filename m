Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:53958 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaIKNl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 09:41:28 -0400
Received: by mail-qc0-f173.google.com with SMTP id w7so21038175qcr.18
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2014 06:41:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1410281416.2770593.165489213.019D33E6@webmail.messagingengine.com>
References: <CACHGq=AYtyCh2s_h_UtBtnH4TdHuw+gHeXhKjT2kVQSLcBSrow@mail.gmail.com>
	<540ED666.9070101@broadcom.com>
	<20140909132623.GD29412@tuxdriver.com>
	<1410281416.2770593.165489213.019D33E6@webmail.messagingengine.com>
Date: Thu, 11 Sep 2014 19:11:27 +0530
Message-ID: <CACHGq=CQXKfwEYHH5ZnB8vkCfLc6dng4+G=4Aa8ApgLy_52pnA@mail.gmail.com> (sfid-20140911_154131_501260_6729C2E3)
Subject: Re: Mesh Support in brcmsmac
From: chandrika parimoo <chandrika3437@gmail.com>
To: Thomas Pedersen <thomas@noack.us>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there any work already done or is being done to get the mesh
support on brcmsmac  driver (I can see that b43 and b43legacy already
has mesh support)?
Since b43 has no support for BCM4313 chipsets so using b43 is not an
option in my case. Also, will making changes to  brcmsmac be
sufficient or will there be a requirement for firmware changes to
achieve mesh support?

On Tue, Sep 9, 2014 at 10:20 PM, Thomas Pedersen <thomas@noack.us> wrote:
> On Tue, Sep 9, 2014, at 06:26 AM, John W. Linville wrote:
>> On Tue, Sep 09, 2014 at 12:28:54PM +0200, Arend van Spriel wrote:
>> > + linux-wireless
>> >
>> > On 09/09/14 12:22, chandrika parimoo wrote:
>> > >Hello,
>> > >
>> > >I have broadcom bcm4313 card and am using brcmsmac driver which does not
>> > >have mesh support currently.
>> > >I wanted to know if there is a workaround for it?
>> >
>> > No workaround. I am not familiar with wireless mesh networking. I suppose
>> > there are people on the linux-wireless mailing list who know what is needed
>> > from a mac80211 driver (like brcmsmac) to enable mesh networking.
>>
>> The main things is the beacons, no?
>
> Yeah mainly beacons, but also 4addr frames and FIF_OTHER_BSS filter.
>
> --
> thomas
