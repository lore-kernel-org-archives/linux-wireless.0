Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52016 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab0LFWdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 17:33:47 -0500
Received: by qyk11 with SMTP id 11so4177832qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 14:33:46 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 6 Dec 2010 16:33:46 -0600
Message-ID: <AANLkTi=-pv_s42gDw-7ETkz15AMSY+qG8RaZpskYCaVm@mail.gmail.com>
Subject: I/O error
From: alfred steele <alfred.jaquez@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like this was available only from 0.7.x onwards. I upgraded to
0.7.3 and got the following error:
wpa_supplicant -B -Dwext -ieth1 -c /ubifs/wifi/wpa_supplicant.conf
ioctl[SIOCGIWMODE]: Input/output error
[404171.320598] unifi0: unifi_siwessid: Join failed, status -5
ioctl[SIOCSIWESSID]: Input/output error

>From what i could understand, this means is that the "SIOCGIWMODE"
(get operation mode) is unsuccesful.
Is it because of lack of support on some layer e.g. wireless ext. etc.?
Thanks.
