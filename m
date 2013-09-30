Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:45719 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab3I3VZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 17:25:43 -0400
Received: by mail-oa0-f52.google.com with SMTP id n2so4081922oag.25
        for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 14:25:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130930211115.GA29102@pogo>
References: <1380206258-16452-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<20130930164840.GB15780@pandem0nium>
	<20130930211115.GA29102@pogo>
Date: Mon, 30 Sep 2013 23:25:42 +0200
Message-ID: <CAA2SeNJ47Rur8u5CeoQrULQRsKaiWATV8DA0VuSjrEB2B3=+VQ@mail.gmail.com> (sfid-20130930_232547_824071_A0D152B6)
Subject: Re: [RFC] ath9k: add HT40 spectral scan capability
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon developed this UI:
https://github.com/simonwunderlich/FFT_eval
I developed a new one using qt-qwt (not compiled statically) in order
to support scan on HT40 channels:
https://github.com/LorenzoBianconi/ath_spectral
It is not finalized yet since I have to review it using Simon's
suggestions for the new format of "fft_sample" data structure.

Cheers,
Lorenzo

2013/9/30 Luis R. Rodriguez <rodrigue@qca.qualcomm.com>:
> On Mon, Sep 30, 2013 at 06:48:40PM +0200, Simon Wunderlich wrote:
>> On Thu, Sep 26, 2013 at 04:37:38PM +0200, Lorenzo Bianconi wrote:
>>
>> One more thing: please don't change the format for HT20 -
>> there are already userspace programs which rely on the order
>> of the parameters as they are now.
>
> Great, where are these userpace programs?
>
>   Luis



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
