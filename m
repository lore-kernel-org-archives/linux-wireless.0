Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:24164 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZC3SsC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 14:48:02 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2721663wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 11:48:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49CFDB1F.7040902@hauke-m.de>
References: <49CFD043.6020708@tls-tautenburg.de> <49CFDB1F.7040902@hauke-m.de>
Date: Mon, 30 Mar 2009 11:47:45 -0700
Message-ID: <43e72e890903301147hc09cec7rc8f214450a53efa7@mail.gmail.com> (sfid-20090330_204807_953325_EA020424)
Subject: Re: compile error compat-wireless-2009-03-29
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Bringfried Stecklum <stecklum@tls-tautenburg.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 29, 2009 at 1:33 PM, Hauke Mehrtens <hauke@hauke-m.de> wrot=
e:
> Bringfried Stecklum wrote:
>> When trying to compile the latest compat-wireless packagev
>> (2.6.29-20327-g8f2487d) on an Ubuntu 8.10 system running linux kerne=
l
>> 2.6.27-12 I get the following error
>>
>> /home/stecklum/System/src/compat-wireless-2009-03-29/net/mac80211/ag=
g-tx.c:
>> In function =E2=80=98ieee80211_agg_splice_packets=E2=80=99:
>> /home/stecklum/System/src/compat-wireless-2009-03-29/net/mac80211/ag=
g-tx.c:385:
>> error: implicit declaration of function =E2=80=98skb_queue_splice_ta=
il_init=E2=80=99
>> make[3]: ***
>> [/home/stecklum/System/src/compat-wireless-2009-03-29/net/mac80211/a=
gg-tx.o]
>> Error 1
>> make[2]: ***
>> [/home/stecklum/System/src/compat-wireless-2009-03-29/net/mac80211] =
Error 2
>> make[1]: ***
>> [_module_/home/stecklum/System/src/compat-wireless-2009-03-29] Error=
 2
>> make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-12-mygener=
ic'
>> make: *** [modules] Error 2
>
> Hi,
>
> This is already know. The patch can be found here:
> http://marc.info/?l=3Dlinux-wireless&m=3D123825765019764

This is now merged, please try now Bringfried.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
