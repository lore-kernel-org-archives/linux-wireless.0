Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44245 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab3AHTbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 14:31:07 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so40319wib.7
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2013 11:31:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomJiw8cZqiPRCa8iDrTJdhwtWTTVQwMcHnnyft+DquR1Q@mail.gmail.com>
References: <1357652938-18836-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<CAJ-VmomJiw8cZqiPRCa8iDrTJdhwtWTTVQwMcHnnyft+DquR1Q@mail.gmail.com>
Date: Tue, 8 Jan 2013 11:31:05 -0800
Message-ID: <CAJ-Vmom8XFaPwOamGwqcG1sZaDyjodUbhgPFNHONBAYnr1eEBA@mail.gmail.com> (sfid-20130108_203112_592829_2EF9094D)
Subject: Re: [PATCH] ath9k: add spectral scan feature
From: Adrian Chadd <adrian@freebsd.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. I've also included Zefir's code to populate the HT20 spectral
sample results in an abstract representation, including raw, adj and
dBm magnitude values:

http://svn.freebsd.org/base/user/adrian/ath_radar_stuff/lib/libradarpkt/

look in ar9280_radar.c .

I'll work on HT40 sample decoding and dBm decoding soon.



Adrian
