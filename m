Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43092 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1C0Lxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2011 07:53:35 -0400
Received: by wya21 with SMTP id 21so2164614wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Mar 2011 04:53:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D8E96B5.7090707@lockie.ca>
References: <4D8E96B5.7090707@lockie.ca>
Date: Sun, 27 Mar 2011 17:23:32 +0530
Message-ID: <AANLkTimNtNruB5Maoa5EOkK_zJ35oEsP35-f8jvS88hm@mail.gmail.com>
Subject: Re: what does this mean
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 27, 2011 at 7:15 AM, James <bjlockie@lockie.ca> wrote:
> I tried the 2011 03 26 compat-wireless and it gives this error when I
> try a scan (it finds some networks but I know there are more).
>
> sudo iw dev wlan0 scan | grep -i ssid
>
> ath: timeout (100000 us) on reg 0x9c20: 0x00000000 & 0x00000001 !=
> 0x00000001
> ath: Could not kill baseband RX

James, this is a fatal error.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
