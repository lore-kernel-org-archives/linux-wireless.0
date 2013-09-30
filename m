Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:40043 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab3I3WBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 18:01:13 -0400
Received: by mail-oa0-f51.google.com with SMTP id h16so4130089oag.24
        for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 15:01:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VrOTUmpEpwM=4-p6smhDdi32S4en9TmzLUZH5rGTj9Hg@mail.gmail.com>
References: <1380206258-16452-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<20130930164840.GB15780@pandem0nium>
	<20130930211115.GA29102@pogo>
	<CAA2SeNJ47Rur8u5CeoQrULQRsKaiWATV8DA0VuSjrEB2B3=+VQ@mail.gmail.com>
	<CAB=NE6VrOTUmpEpwM=4-p6smhDdi32S4en9TmzLUZH5rGTj9Hg@mail.gmail.com>
Date: Tue, 1 Oct 2013 00:01:12 +0200
Message-ID: <CAA2SeN+QLPX2omZ_2iDzzRSv1PDOBoify+XfZHB7mmQku531FQ@mail.gmail.com> (sfid-20131001_000117_744480_0701A6E5)
Subject: Re: [RFC] ath9k: add HT40 spectral scan capability
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, I will review the patch first and then I will upgrade the UI and
documentation
Regards,

Lorenzo

2013/9/30 Luis R. Rodriguez <mcgrof@do-not-panic.com>:
> On Mon, Sep 30, 2013 at 2:25 PM, Lorenzo Bianconi
> <lorenzo.bianconi83@gmail.com> wrote:
>> Simon developed this UI:
>> https://github.com/simonwunderlich/FFT_eval
>> I developed a new one using qt-qwt (not compiled statically) in order
>> to support scan on HT40 channels:
>> https://github.com/LorenzoBianconi/ath_spectral
>> It is not finalized yet since I have to review it using Simon's
>> suggestions for the new format of "fft_sample" data structure.
>
> OK great! Then agreed with you. Can you please document spectral scan
> progress somewhere here:
>
> http://wireless.kernel.org/en/users/Drivers/ath9k
>
>  Maybe a new section? Pointers to the applications would be great too!
>
>  Luis



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
