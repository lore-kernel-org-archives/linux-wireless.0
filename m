Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:37863 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3I3Vrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 17:47:53 -0400
Received: by mail-la0-f52.google.com with SMTP id ev20so5007737lab.39
        for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 14:47:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA2SeNJ47Rur8u5CeoQrULQRsKaiWATV8DA0VuSjrEB2B3=+VQ@mail.gmail.com>
References: <1380206258-16452-1-git-send-email-lorenzo.bianconi83@gmail.com>
 <20130930164840.GB15780@pandem0nium> <20130930211115.GA29102@pogo> <CAA2SeNJ47Rur8u5CeoQrULQRsKaiWATV8DA0VuSjrEB2B3=+VQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 30 Sep 2013 14:47:31 -0700
Message-ID: <CAB=NE6VrOTUmpEpwM=4-p6smhDdi32S4en9TmzLUZH5rGTj9Hg@mail.gmail.com> (sfid-20130930_234756_500949_CB540F18)
Subject: Re: [RFC] ath9k: add HT40 spectral scan capability
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 30, 2013 at 2:25 PM, Lorenzo Bianconi
<lorenzo.bianconi83@gmail.com> wrote:
> Simon developed this UI:
> https://github.com/simonwunderlich/FFT_eval
> I developed a new one using qt-qwt (not compiled statically) in order
> to support scan on HT40 channels:
> https://github.com/LorenzoBianconi/ath_spectral
> It is not finalized yet since I have to review it using Simon's
> suggestions for the new format of "fft_sample" data structure.

OK great! Then agreed with you. Can you please document spectral scan
progress somewhere here:

http://wireless.kernel.org/en/users/Drivers/ath9k

 Maybe a new section? Pointers to the applications would be great too!

 Luis
