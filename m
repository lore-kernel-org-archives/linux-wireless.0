Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41923 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab2INLwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 07:52:33 -0400
Received: by obbuo13 with SMTP id uo13so6081864obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Sep 2012 04:52:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20562.63507.607989.546536@gargle.gargle.HOWL>
References: <20562.57519.298444.874991@gargle.gargle.HOWL>
	<CAD2nsn0paBt4YyyCp0-iuJ9xxQctRhdL+TtVh1bovM2WMt4MzQ@mail.gmail.com>
	<20562.63507.607989.546536@gargle.gargle.HOWL>
Date: Fri, 14 Sep 2012 17:22:32 +0530
Message-ID: <CAD2nsn1XmH9656pXnv820BJ6ta0QxNZeX-fhRA+CPkU6KZ4HfA@mail.gmail.com> (sfid-20120914_135237_114540_79D34C9D)
Subject: Re: [RFC 7/8] ath9k: Add a module parameter to enable diversity for
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Sujith Manoharan <c_manoha@qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 14, 2012 at 2:55 PM, Sujith Manoharan <c_manoha@qualcomm.com> wrote:
> Mohammed Shafi wrote:
>> > +static int ath9k_enable_diversity;
>> > +module_param_named(enable_diversity, ath9k_enable_diversity, int, 0444);
>> > +MODULE_PARM_DESC(enable_diversity, "Enable Antenna diversity for AR9565");
>>
>> is it specific for AR9565 alone, we have AR9285, AR9485 .
>
> For AR9565 only, this is needed because we are sharing the BT antenna.

oops, i missed the 6th patch, where this seems to be a new API for AR9565 (for
BTCOEX alone). thanks!

>
> Sujith



-- 
thanks,
shafi
