Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33080 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab2ENQKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 12:10:15 -0400
Received: by bkcji2 with SMTP id ji2so3984638bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 09:10:13 -0700 (PDT)
Message-ID: <4FB12E62.4030905@gmail.com> (sfid-20120514_181019_641249_0BC13AAB)
Date: Mon, 14 May 2012 18:10:10 +0200
From: =?ISO-8859-1?Q?Mustafa_Y=FCcel?= <yuecelm@gmail.com>
MIME-Version: 1.0
To: yoni.divinsky@ti.com
CC: coelho@ti.com, linux-wireless@vger.kernel.org
Subject: wl12xx: extend survey with channel_time_tx, channel_busy_time and
 channel_time
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yoni,

I try to get this feature working with hostapd and wl12xx:
http://linuxwireless.org/en/users/Documentation/acs

currently only the noise of the main channel is filled within the
wl1271_op_get_survey function. but to get acs working, in need to fill
channel_time, channel_time_tx and channel_busy_time in the survey. is it
somehow possible to get these values (or similar values like a duty
cycle value) from the firmware? the only requirement I see as far, is
that it should measure these values inside a ROC phase...

Thanks,
Musti
