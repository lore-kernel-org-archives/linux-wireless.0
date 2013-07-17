Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:64500 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab3GQLsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jul 2013 07:48:50 -0400
Received: by mail-qa0-f52.google.com with SMTP id bv4so1047817qab.11
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jul 2013 04:48:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130716102743.GA8321@redhat.com>
References: <20130107110759.GC6931@redhat.com> <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com> <CAJZjf_xoCOTFsLAB29uLKeW7+O+k255Amspn6GKFMysc7CTsBg@mail.gmail.com>
 <CAJZjf_xGdvStOG0=FR2+2WsVcjyizQukH+RxysZf8f9-Tk9L9w@mail.gmail.com>
 <20130611161924.GB1696@redhat.com> <CAJZjf_zOF=qGEE=pWDRe0YDpAYophm93cVM8pfuL0sTRGq56EA@mail.gmail.com>
 <20130614131829.GA5125@redhat.com> <20130625142514.GA1938@redhat.com>
 <CAJZjf_z=+QW_Y3yuz6nJ+muVA_6bGRut8EQ7fCopDqqj2Fn9Yw@mail.gmail.com> <20130716102743.GA8321@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Wed, 17 Jul 2013 12:48:30 +0100
Message-ID: <CAJZjf_y9fnkHLp4YPdYY2sVo4r4+hKJcZAebJmjVKCBh-0EUtA@mail.gmail.com> (sfid-20130717_134854_197986_CBC6DC63)
Subject: Re: Power saving features for iwl4965
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 16, 2013 at 11:27 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> I seem only to be able to trigger it with disable_hw_scan=0, I need
>> further testing with disable_hw_scan=1 (I use disable_hw_scan=0
>> because it prevents me from getting disconnected from eduroam Cisco
>> APs -- haven't tested disable_hw_scan=0 since the VOIP-friendly SW
>> scanning patch, however).
>>
>> Do you want the log anyway? (modprobe iwl3945 debug=0x47ffffff
>> disable_hw_scan=0 and runtime PCI powersave also enabled -- I don't
>> know if it matters).
>
> As this is not causing troubles with default disable_hw_scan option,
> I'll post that patch.

My mistake, I can trigger error conditions _independently_ of
disable_hw_scan option being enabled or disabled, as long as powersave
is enabled.

I'll send you a private email with the logs.
