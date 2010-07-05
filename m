Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35421 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab0GEQtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 12:49:41 -0400
Received: by fxm14 with SMTP id 14so3886432fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jul 2010 09:49:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimcFgxOmw4oOa28unhmSpTt0jNacFKXRXycKKA9@mail.gmail.com>
References: <AANLkTinOcy-n6EVzAasAJO1I2yNeWOiaCid0tGdxnuwa@mail.gmail.com>
	<AC090B9732AB2B4DB7FF476E907FE660010673660C@dnce02.ent.ti.com>
	<AANLkTimcFgxOmw4oOa28unhmSpTt0jNacFKXRXycKKA9@mail.gmail.com>
Date: Mon, 5 Jul 2010 18:49:39 +0200
Message-ID: <AANLkTikWzx5SZUxZ9qg5Y9jY44YzZlDvs1kSwbFET76H@mail.gmail.com>
Subject: Re: wl1271 firmware
From: Pazzo Da Legare <pazzodalegare@gmail.com>
To: "Levi, Shahar" <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Shahar,

I start from tiwlan.ini file for tiwlan driver to produce an nvs file.

Could you please indicate values to use for the following parameters
of struct wl1271_nvs_file: general_params.srf1[],
general_params.srf2[], general_params.srf3[],
dyn_radio_params_2[].params.degraded_low_to_normal_thr,
dyn_radio_params_2[].params.normal_to_degraded_high_thr,
dyn_radio_params_5[i].params.degraded_low_to_normal_thr,
dyn_radio_params_5[i].params.normal_to_degraded_high_thr

Thank you very much for your time,

Best Regards,

pz


2010/7/5 Pazzo Da Legare <pazzodalegare@gmail.com>:
> Hi Shahar,
>
> Did you have any news about nvs file? I wrote an email to driver's
> mantaneir too,
>
> Thank you in advance,
>
> pz
>
> 2010/6/30 Levi, Shahar <shahar_levi@ti.com>:
>> Hi pz,
>> I am checking the way to access the FW and NVS file of wl1271.
>> Let me find more details on that and get back to you.
>> Regards,
>> Shahar
>> -----Original Message-----
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Pazzo Da Legare
>> Sent: Wednesday, June 30, 2010 2:27 PM
>> To: linux-wireless@vger.kernel.org
>> Subject: wl1271 firmware
>>
>> Hi all,
>>
>> I'm looking for wl1271 firmwares. I found wl1271-fw.bin but I cannot
>> find wl1271-nvs.bin needed to use the wl1271's driver.
>> Could you please indicate where I can get it?
>>
>> Thank in advance,
>>
>> pz
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
