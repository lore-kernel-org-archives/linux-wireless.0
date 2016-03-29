Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35313 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121AbcC2MPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 08:15:38 -0400
Received: by mail-ig0-f176.google.com with SMTP id cl4so74343217igb.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2016 05:15:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56FA6B07.9000807@broadcom.com>
References: <CAAeNHhzywKhugKCPwLonXqTEnJJm7Td39JPof0xRxL+gOZ_xkg@mail.gmail.com>
	<56FA6B07.9000807@broadcom.com>
Date: Tue, 29 Mar 2016 17:45:37 +0530
Message-ID: <CAAeNHhz6ok+ade9N1uTxZOCrSjKvecaNVhdwodj_8JFaj5eaDQ@mail.gmail.com> (sfid-20160329_141543_561056_1D095307)
Subject: Re: Wireless Encryption
From: Aswin Paranji <aswin.paranji@gmail.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend,

Thanks for the response. What I'm trying to accomplish is to encrypt
the 802.11 data packet that is sent to mac80211 as data frames and
mac80211 sends it to the wifi driver.
I took a look at this blog
"https://www.linux.com/community/blogs/133-general-linux/816721-linux-wireless-networking-a-short-walk"
and thought it would be possible to just encrypt the data part.

I also checked using wireshark where the 80211 data is encrypted using
the wpa key and ssid. I'm looking for a way to encrypt data with out
touching any wifi drivers.

I'am trying to use openwrt to come up with new encryption and see if i
can use it in rapberry pi as a test bed.


Appreciate if you can help.

Regards,
Aswin

On Tue, Mar 29, 2016 at 5:16 PM, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 29-3-2016 13:09, Aswin Paranji wrote:
>> Hi,
>> I'm trying to encrypt the 802.11 data with my own encryption instead
>> of WEP or WPA. Can anybody guide me on how to do that and where I need
>> to change. I'm trying to do this with Raspberry PI 3 device.
>
> Umm. You mean you want to do it with the integrated wifi chipset on
> RPi3. You can basically forget about that. Encryption is done on the
> wifi device. The kernel passes 802.3 packets down to the device so there
> is nothing to encrypt at that level and the device/firmware does not
> have a way for you to plugin a different encryption.
>
> Regards,
> Arend
>
>> Appreciate if you can guide me.
>>
>> Regards,
>> Aswin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
