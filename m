Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53550 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2HBSmo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 14:42:44 -0400
Received: by wibhr14 with SMTP id hr14so5417165wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2012 11:42:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120802165429.29839020@dualc.maya.org>
References: <5016F03F.1020508@t-online.de>
	<5016F59E.9070101@01019freenet.de>
	<CANUX_P2CZW5ji--KkXoyBZUuZfOqkPk_A8Ui9tw4rNeuY=mebQ@mail.gmail.com>
	<5019EC7D.5030208@01019freenet.de>
	<CANUX_P10yfdy+d9txsp1RV9niKex_5WAr0VFsjsMiPosv6M+mA@mail.gmail.com>
	<20120802165429.29839020@dualc.maya.org>
Date: Thu, 2 Aug 2012 21:42:43 +0300
Message-ID: <CANUX_P1corc7rp_MRrV=MuDRXqqibmxL9MXwhE=zrkNSNfWqzg@mail.gmail.com> (sfid-20120802_204257_947679_07E2F0D5)
Subject: Re: No WLAN on DELL XPS L702x with Ubuntu 12.04LTS (64Bit)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "Ch. Hanisch" <ch-hanisch@t-online.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>
>>> He wrote, too, that the installation of compat-wireless
>>> (unfortunately, he didn't told me which version), didn't changed the
>>> situation.
>>>
>>> I attached for him the output of
>>> options iwlwifi debug=0xffffffff
>>>
>>> The last part of it:
>>
>> what about the logs *before* that?
>
> What are you missing? The attachment contains of 1739 lines. It seems to
> be the complete output from dmesg from 0 to 675 seconds!
>
Sorry - I missed the attached file. Ok so you are using the latest fw
and you get a FW in INIT stage.
Please file a bug.
I thought it would be a quick and easy issue - but apparently it is not... Sorry
