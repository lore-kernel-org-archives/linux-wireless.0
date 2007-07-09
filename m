Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:63283 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbXGIVvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 17:51:09 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1589401wah
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2007 14:51:08 -0700 (PDT)
Message-ID: <59abf66e0707091451p3913ba5enf35edd934840b3cb@mail.gmail.com>
Date: Mon, 9 Jul 2007 18:51:08 -0300
From: "=?ISO-8859-1?Q?Jorge_Luc=E1ngeli_Obes?=" <t4m5yn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Monitor mode with RTL8187
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I've come into possession of a RTL8187-based wireless USB adapter
(Encore ENUWI-G2). I am trying the new RTL8187 driver in wireless-dev
GIT. The question is: does this driver support monitor mode?

tamsyn@rory:~$ sudo iwconfig wlan0 mode monitor
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Device or resource busy.

Any clues? Please CC me as I'm not subscribed to the list. Thanks in advance.

Jorge
