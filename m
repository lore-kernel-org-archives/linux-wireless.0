Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from briare1.fullpliant.org ([78.227.24.35]:56371 "HELO
	briare1.fullpliant.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753457Ab1CBRBx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 12:01:53 -0500
From: Hubert Tonneau <hubert.tonneau@fullpliant.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 32 bits executables with 64 bits kernel wifi issue
Date: Wed, 02 Mar 2011 18:03:06 GMT
Message-ID: <0B34I5711@briare1.fullpliant.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
>
> Does your version of wpa_supplicant support the "-Dnl80211" option
> (instead of "-Dwext")?  It might be worth trying that to see if it
> works better?

Your assertion that I was using -Dwext was right.

The WPA supplicant I use (v0.6.9) has support for -Dnl80211
and using it does not change the situation: works in 32 bits mode,
does not work on some wifi box with 64 bits kernel and 32 bits executables.

Regards,
Hubert Tonneau
