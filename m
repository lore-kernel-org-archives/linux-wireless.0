Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55696 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3AHPqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 10:46:40 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so453755wgb.12
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2013 07:46:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1357652938-18836-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1357652938-18836-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Date: Tue, 8 Jan 2013 07:46:39 -0800
Message-ID: <CAJ-VmomJiw8cZqiPRCa8iDrTJdhwtWTTVQwMcHnnyft+DquR1Q@mail.gmail.com> (sfid-20130108_164643_622904_2098B344)
Subject: Re: [PATCH] ath9k: add spectral scan feature
From: Adrian Chadd <adrian@freebsd.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hiya,

I've committed some (seemingly) working spectral scan code to
FreeBSD-HEAD. This includes the relevant radar register frobbing to
get HT40 scan results.

Take a look at sys/dev/ath/ath_hal/ar5416/ar5416_spectral.c .

I'm just hacking on your FFT code now (and likely my QT based plotting
code) to plot out live data. Your fft_eval program doesn't really like
some of my spectral dumps (30,000 + entries :-)



Adrian
