Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48519 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaAFNig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 08:38:36 -0500
Received: by mail-pb0-f49.google.com with SMTP id jt11so18259816pbb.8
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 05:38:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1655218.I1JJMSx2BO@debian64>
References: <CAP+W=6QCwL1hbz5fRKuBr7dCS58_fVFTQ-mFjgW5rTr6y6QO-w@mail.gmail.com>
	<1655218.I1JJMSx2BO@debian64>
Date: Mon, 6 Jan 2014 15:38:36 +0200
Message-ID: <CAP+W=6Q1=PCcA2T5gaar960Zek8=sO05UjouwWfX6SpDjrcL6Q@mail.gmail.com> (sfid-20140106_143839_982945_276723AC)
Subject: Re: r92su driver for realtek rtl8192su usb wireless adapter
From: Julian Gordon <jewelsofthought@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian,

Thanks for the reply. After I sent the email, I continued to do some more
investigation, and am presently downloading the OS's needed to upgrade from
12.04 to 13.10 (or 12). I was hoping to be able to remain on 12.04 for its
LTS.

Oh well, that's life in the boonies.

Thanks for this useful tool - especially of those of us living out of the
mainstream, down in the far south of Africa where our device choice is much
more limited.

Regards,
Julian

On Mon, Jan 6, 2014 at 2:37 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Monday, January 06, 2014 11:18:27 AM you wrote:
>> I have downloaded the dirver from http://github.com/chunkeey/rtl8192su for
>> the adapter.
>>
>> Upon running the make, it reports an error: it cannot find
>> IEEE80211_NUM_TIDS in file r92/su/sta.h:120:26.
>>
>> Where can I find the correct defintion for this varaible or an alternative
>> to it?
> Ah, IEEE80211_NUM_TIDS is probably just the tip. There are a few more
> definitions and functions missing for the driver to compile with anything
> older than 3.10 [0].
>
> Either you can update the kernel to 3.10+ (if possible to 3.12). Or, if
> you want to stick with 3.2,0-58-generic, then take a look backports [1]
> project. [However, this is more complicated since you'll have to integrate
> r92su into backports first].
>
> Regards,
>
> Christian
>
> [0] <https://github.com/chunkeey/rtl8192su/issues/1>
> [1] <https://backports.wiki.kernel.org/index.php/Main_Page>
>
>



-- 
Julian Gordon,
South Africa: +27 (021) 650-3210
Cell: +27 (083) 226-5482
Email
--

Not everything that is faced can be changed. But nothing can be
changed until it is faced.
