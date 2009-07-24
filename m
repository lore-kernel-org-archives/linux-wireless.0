Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:35605 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZGXQXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 12:23:44 -0400
Received: by qyk34 with SMTP id 34so344645qyk.33
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 09:23:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A69D8C6.9040103@promwad.com>
References: <4A682BBD.90101@promwad.com> <43e72e890907230917w226c4697v41f907623e5f7d8@mail.gmail.com>
	<4A696D33.8050606@promwad.com> <43e72e890907240824n5bcff378m1278eb948055a9a5@mail.gmail.com>
	<4A69D8C6.9040103@promwad.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 24 Jul 2009 09:23:22 -0700
Message-ID: <43e72e890907240923h41408c99qfe48e4224149cb2d@mail.gmail.com>
Subject: Re: WPA2, compat-wireless-2.6.31-rc3, kernel 2.6.28 - rtl8187 -
	association works but no ping
To: ivan.kuten@promwad.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 24, 2009 at 8:52 AM, Ivan Kuten<ivan.kuten@promwad.com> wrote:
> No Network Manager.
> Just:
> wpa_supplicant -Dwext -iwlan0 -c /home/ACORP.conf -dd &
> /sbin/udhcpc -n -q -i wlan0 -s /bin/default.script

How did you get the eth0 IP? ps -ef?

  Luis
