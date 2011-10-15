Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52847 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab1JOTV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 15:21:26 -0400
Received: by wwe6 with SMTP id 6so407186wwe.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 12:21:25 -0700 (PDT)
Message-ID: <4E99DD2A.6070400@gmail.com> (sfid-20111015_212130_457886_4A953F8D)
Date: Sat, 15 Oct 2011 21:21:14 +0200
From: =?UTF-8?B?RGF2aWQgVMOkaHQ=?= <dave.taht@gmail.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: werner <w.landgraf@ru.ru>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.1-rc9 wifi problem
References: <web-626864831@zbackend1.aha.ru> <4E99D30A.1030108@broadcom.com>
In-Reply-To: <4E99D30A.1030108@broadcom.com>
Content-Type: multipart/mixed;
 boundary="------------000702020505070300070105"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000702020505070300070105
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/15/2011 08:38 PM, Arend van Spriel wrote:
> On 10/15/2011 08:07 PM, werner wrote:
>> A laptop of a friend, which worked always with wifi until 
>> 3.0.4 , stopped to work when installing 3.1-rc9 , after 
>> re-installing 3.0.4 wifi returned to work.  I think it was 
>> a packard-bell laptop.   I can't test this better because 
>> he gone with his laptop; perhaps next week he'll visit me 
>> again. Since 2.6.38 his laptop worked with my wifi.
>>
>> This can be a regression in the wifi drivers, or because 
>> of a slightly changed config. Anyway the diff of config is 
>> enclosed.
>>
>> w.landgraf
>> ---
>> Professional hosting for everyone - http://www.host.ru
> Another thing. As this seems a wireless issue it may be better to send
> this thread to the linux-wireless list.
>

In my case, with 3.1-rc9, an atheros SR71 card stopped apparently
negotiating N - as it would not connect faster than 54Mbit on the 5ghz
channel either in HT20 or HT40+ mode, according to sampling iwconfig.


> Gr. AvS
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Dave Täht


--------------000702020505070300070105
Content-Type: text/x-vcard; charset=utf-8;
 name="dave_taht.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dave_taht.vcf"

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6RGF2ZSBUPUMzPUE0aHQNCm47cXVv
dGVkLXByaW50YWJsZTpUPUMzPUE0aHQ7RGF2ZQ0KZW1haWw7aW50ZXJuZXQ6ZGF2ZS50YWh0
QGdtYWlsLmNvbQ0KdGVsO2hvbWU6MS0yMzktODI5LTU2MDgNCnRlbDtjZWxsOjA2Mzg2NDUz
NzQNCngtbW96aWxsYS1odG1sOkZBTFNFDQp2ZXJzaW9uOjIuMQ0KZW5kOnZjYXJkDQoNCg==
--------------000702020505070300070105--
