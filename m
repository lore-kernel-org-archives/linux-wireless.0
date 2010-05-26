Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38070 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab0EZGZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 02:25:36 -0400
Received: by wyb29 with SMTP id 29so2953392wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 23:25:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <93781E992CBA7843962D8B0E7D683F3C11178EC0E4@SC1EXMB-MBCL.global.atheros.com>
References: <AANLkTimkpbans5mUObR8PWzf2-Uh0K-cZVVg0HjNxnSv@mail.gmail.com>
	 <AANLkTikUhVoBKe95N_kkpXvSEsr845viGp5IhHZTVN2n@mail.gmail.com>
	 <93781E992CBA7843962D8B0E7D683F3C11178EC0E4@SC1EXMB-MBCL.global.atheros.com>
Date: Wed, 26 May 2010 09:25:34 +0300
Message-ID: <AANLkTin4UbuZOfpJ23KLq8HRfVcEKmHAAeEtSSxDE9Vu@mail.gmail.com>
Subject: Re: wireless-regdb: A band is missing for IL
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: David Quan <David.Quan@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Green <Michael.Green@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't know exactly what Unii1 and Unii2 means but, this is the
latest regulatory authoritative document (in hebrew):
http://www.moc.gov.il/sip_storage/FILES/1/1061.pdf
In short:

1. 5150 - 5250
2. 5250 - 5350 DFS mandatory
3. outdoor is forbidden for both
4. 200mW maximum e.i.r.p.
5. 40 Mhz is allowed for all WiFi Alliance equipment in 5.2GHz
6. 40 Mhz is allowed for WiFi Alliance equipment that have "40 MHz
operation in 2.4 GHz, with coexistence mechanisms" only

I know how to enforce 1 - 4. But 5 and 6 is another story....

Anyway, I will send an RFC soon.

Emmanuel Grumbach
egrumbach@gmail.com



On Tue, May 25, 2010 at 23:39, David Quan <David.Quan@atheros.com> wrote:
> Israel follows ETSI3_WORLD,
>  this means
>
> Unii1 + Unii2 is supported. Unii2 requires DFS for APs.
>
> 2ghz Ch1-13 supported.
>
>
> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com]
> Sent: Tuesday, May 25, 2010 12:08 PM
> To: Emmanuel Grumbach; Michael Green; David Quan
> Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
> Subject: Re: wireless-regdb: A band is missing for IL
>
> Michael, please review and let us know what you think.
>
>  Luis
>
> On Tue, May 25, 2010 at 12:03 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> According to http://en.wikipedia.org/wiki/List_of_WLAN_channels#5.C2.A0GHz_.28802.11a.2Fh.2Fj.2Fn.29
>>
>> Channels 34 - 64 are allowed in 20 Mhz in Israel. This is not what is
>> written in db.txt:
>>
>> country IL:
>>         (2402 - 2482 @ 40), (N/A, 20)
>>
>> This wikipedia page relies on an official page from the Israel
>> Ministry of the Communication.
>>
>> Emmanuel Grumbach
>> egrumbach@gmail.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
