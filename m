Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59435 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab0GPVl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 17:41:26 -0400
Received: by fxm14 with SMTP id 14so1343792fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jul 2010 14:41:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE660010685F34E@dnce02.ent.ti.com>
References: <4C37BCA0.5090607@deltatee.com>
	<AC090B9732AB2B4DB7FF476E907FE660010685F34E@dnce02.ent.ti.com>
Date: Fri, 16 Jul 2010 23:41:24 +0200
Message-ID: <AANLkTilHNKeRZX5CMplyriTo2hTPBrz_z1_Zpwoy3SZx@mail.gmail.com>
Subject: Re: wl1271 firmware
From: Pazzo Da Legare <pazzodalegare@gmail.com>
To: "Levi, Shahar" <shahar_levi@ti.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Shahar,
Thank you for your help and the news. Could you please indicate a link
when available?
Pz

2010/7/11, Levi, Shahar <shahar_levi@ti.com>:
>> -----Original Message-----
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] On Behalf Of Logan Gunthorpe
>> Sent: Saturday, July 10, 2010 3:20 AM
>> To: Luciano Coelho
>> Cc: linux-wireless@vger.kernel.org
>> Subject: RE: wl1271 firmware
>>
>> Hi Everyone,
>>
>> I too am working with a WL1271 module and have just today got it
>> connected to an Atmel ARM9 development kit (AT91SAM9G45-EKES). So far it
>> appears to work but I have been gated by the firmware and NVS file issues.
>>
>> I have a firmware binary, but it seems to be a newer version
>> (6.1.3.01.5) than what you are using. Does anyone have any idea if this
>> version will work? It seems to be the only one available on TI's
>> website. Additionally, our device manufacturer has been hesitant to
>> provide any support because we are on an unsupported platform and opted
>> to use the open source driver. Are there any other ways to obtain an
>> older version of the firmware?
>>
>> The NVS file is another problem. TI's website has instructions to use a
>> cryptic tool that appears to come with their driver package. There is no
>> source for this tool and for obvious reasons would not work for us.
>>
>> Anyway, I'd like to help in anyway I can. I've taken a look at the
>> twilan.ini file and I see the commonality with wl1271_ini.h. It would be
>> relatively easy to write a tool that parses the INI file and generates
>> the common part of the NVS file. However, I'd have no idea how to
>> generate the device specific calibration or the few fields missing from
>> the INI file.
>>
>> Thanks,
>>
>> Logan
>>
>
> Hi Logan,
> I am pushing to get access to the correct FW and NVS files version in TI
> web. I believe the community wills nave access of those files this week.
> Regarding the tool to generate the NVS file in the correct format, I will
> check that and reply.
> Regards,
> Shahar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Inviato dal mio dispositivo mobile
