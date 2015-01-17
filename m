Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:52071 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbbAQR7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2015 12:59:33 -0500
Received: by mail-qc0-f181.google.com with SMTP id l6so12624491qcy.12
        for <linux-wireless@vger.kernel.org>; Sat, 17 Jan 2015 09:59:32 -0800 (PST)
MIME-Version: 1.0
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Sat, 17 Jan 2015 21:59:17 +0400
Message-ID: <CACaajQsqPMzwD=EqdD5_XfWAPmkn-52VVNHF1ntFZ6ofEH4D-w@mail.gmail.com> (sfid-20150117_185937_345825_2DE62B6C)
Subject: b43 bcm43228 and linux 3.18.3
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all. I have 3.18.3 kernel and bcm43228, firstly all works fine, but
after connection with my zyxel router i can't ping it ip (after 1-2
min). Connection worked fin, but nothing transmitted =(.
I'm try to disable qos, but this not helps, i'm try to enable
verbose=3, but in dmesg nothing interesting. Time after time b43
driver moved from 5Ghz to 2.4Ghz to 5Ghz and so.
How can i debug this issue? I'm realy love free opensource drivers.
Thanks

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
