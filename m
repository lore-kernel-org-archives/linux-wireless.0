Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56567 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab2EZRup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 13:50:45 -0400
Received: by dady13 with SMTP id y13so2511102dad.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 May 2012 10:50:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9532BE30-26F1-42CF-9300-C25585B29300@gmail.com>
References: <4FC04B5A.1070900@candelatech.com>
	<20416.19680.571601.549629@gargle.gargle.HOWL>
	<7759D07D-C2C8-48D8-8F44-687C7E85D188@gmail.com>
	<20416.35246.76971.129331@gargle.gargle.HOWL>
	<CAPsaeQPxh0Yd+GT3HbReAAtoPhKF2c3kOzgOPL6xK7NC=8J4qA@mail.gmail.com>
	<4FC0CE2B.9060005@openwrt.org>
	<9532BE30-26F1-42CF-9300-C25585B29300@gmail.com>
Date: Sat, 26 May 2012 10:50:44 -0700
Message-ID: <CAJ-VmomdZ+ww=iXF8R+st5HenGjchaV4De2pzzuY6Bu=6_n1YA@mail.gmail.com> (sfid-20120526_195101_971631_C3094B48)
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
From: Adrian Chadd <adrian@freebsd.org>
To: Joe Semler <josef.semler@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

If the device EEPROM states that it's a 2x2/3x3 device, it'll TX on
two/three streams.

If it's something like an AR9281 where it's physically a 1T2R stream
device, that's what it'll transmit/receive on by default.

If it's something like an AR9285 where it's physically a 1T1R stream
device with antenna diversity, that's also what you get.

If the device EEPROM lies though, well, that's a problem. :-)


Adrian
