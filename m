Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52434 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1GDUmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 16:42:37 -0400
Received: by fxd18 with SMTP id 18so5542245fxd.11
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 13:42:36 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alex <alex9434@gmail.com>
Subject: Re: carl9170: Problems setting up Virtual Interface
Date: Mon, 4 Jul 2011 22:42:25 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAMJnVwmtNBrAbaL5TU-pQO+cvFn=UJC2rQroJeYASL3zJEesaw@mail.gmail.com> <201107042223.33968.chunkeey@googlemail.com> <CAMJnVwm0WE_T=GztegJaTp_kZttAQnWi_jgbXHk-S6HgP2OyKQ@mail.gmail.com>
In-Reply-To: <CAMJnVwm0WE_T=GztegJaTp_kZttAQnWi_jgbXHk-S6HgP2OyKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107042242.25197.chunkeey@googlemail.com> (sfid-20110704_224240_501118_F8D05442)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, July 04, 2011 10:29:06 PM Alex wrote:
> I am quite new to this and don't know how to bring this up to connect
> to my router (with WPA2 encryption). ifup does not work:
> 
> ifup wlan1-wlan0
> Ignoring unknown interface wlan1-wlan0=wlan1-wlan0.
be careful there.
The device has only one radio and there's no channel manager.
As soon as the station is up, it will start scanning and this
takes the AP out-of-order... 
