Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58959 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1GYPMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 11:12:36 -0400
Received: by iyb12 with SMTP id 12so4703997iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 08:12:35 -0700 (PDT)
Message-ID: <4E2D87D6.30503@lwfinger.net> (sfid-20110725_171239_844774_A5BF8DBD)
Date: Mon, 25 Jul 2011 10:12:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Lubomir Schmidt <gentoo.lubomir@googlemail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	'George0505' <george0505@realtek.com>
Subject: Re: Support for Realtek 8188RU Chipset in rtl8192cu driver?
References: <CAHFBKjfHfAvpxGhhvRFwni9EVXdSC3HA1WxMJRzVm9SxvowmWQ@mail.gmail.com>
In-Reply-To: <CAHFBKjfHfAvpxGhhvRFwni9EVXdSC3HA1WxMJRzVm9SxvowmWQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090605080603040408010505"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090605080603040408010505
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/25/2011 06:47 AM, Lubomir Schmidt wrote:
> What distribution did you mean?
>
> The old AWUS036H had the Realtek 8187L, yes. Then there came out before nearly
> an year the AWUS036NH and the AWUS036NEH. Both base on the Ralink 3070L Chipset
> and have till today the best range of all devices on the market.
> Now Alfa release the AWUS036NHR with the Realtek 8188RU and the AWUS036NHA with
> an Atheros AR9271.
>
> Last year i helped to get support for the Ralink Chipsets in the 2800usb driver.
> I got white papers and so on from the chipsets and the driver developer could
> connect to an laptop running 24/7 and make tests with the device.
>
> How can i help to get support? What distribution did you prefere on the notebook
> to connect to?

When I looked at the driver, it turned out to be the driver for the RTL8192CU 
with new additional device IDs. Please try the attached patch for any 2.6.39 or 
later kernel. Meanwhile, I will see what other changes have been made to the driver.

Larry

--------------090605080603040408010505
Content-Type: text/plain;
 name="rtl8192cu_add_new_device"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rtl8192cu_add_new_device"

SW5kZXg6IHdpcmVsZXNzLXRlc3RpbmctbmV3L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdp
ZmkvcnRsODE5MmN1L3N3LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gd2lyZWxlc3MtdGVzdGluZy1u
ZXcub3JpZy9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3J0bDgxOTJjdS9zdy5jCisr
KyB3aXJlbGVzcy10ZXN0aW5nLW5ldy9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3J0
bDgxOTJjdS9zdy5jCkBAIC0yODEsNiArMjgxLDggQEAgc3RhdGljIHN0cnVjdCB1c2JfZGV2
aWNlX2lkIHJ0bDgxOTJjX3VzYgogCXtSVExfVVNCX0RFVklDRShVU0JfVkVOREVSX0lEX1JF
QUxURUssIDB4ODE3ZCwgcnRsOTJjdV9oYWxfY2ZnKX0sCiAJLyogODE4OENFLVZBVSBVU0Ig
bWluQ2FyZCAoYi9nIG1vZGUgb25seSkgKi8KIAl7UlRMX1VTQl9ERVZJQ0UoVVNCX1ZFTkRF
Ul9JRF9SRUFMVEVLLCAweDgxN2UsIHJ0bDkyY3VfaGFsX2NmZyl9LAorCS8qIDgxODhSVSBp
biBBbGZhIEFXVVMwMzZOSFIgKi8KKwl7UlRMX1VTQl9ERVZJQ0UoVVNCX1ZFTkRFUl9JRF9S
RUFMVEVLLCAweDgxN2YsIHJ0bDkyY3VfaGFsX2NmZyl9LAogCS8qIDgxODggQ29tYm8gZm9y
IEJDNCAqLwogCXtSVExfVVNCX0RFVklDRShVU0JfVkVOREVSX0lEX1JFQUxURUssIDB4ODc1
NCwgcnRsOTJjdV9oYWxfY2ZnKX0sCiAK
--------------090605080603040408010505--
