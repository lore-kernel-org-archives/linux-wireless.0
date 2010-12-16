Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59573 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab0LPUna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 15:43:30 -0500
Received: by qwa26 with SMTP id 26so3661280qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 12:43:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <370262.79515.qm@web56806.mail.re3.yahoo.com>
References: <599567.31181.qm@web56805.mail.re3.yahoo.com>
	<370262.79515.qm@web56806.mail.re3.yahoo.com>
Date: Thu, 16 Dec 2010 21:43:29 +0100
Message-ID: <AANLkTi=img36VOkKapcgZz54ZmtXRneai-W0bU_W5z=E@mail.gmail.com>
Subject: Re: [PATCH 04/17] rt2x00: fix hang when unplugging USB device in use
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: js@sig21.net, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Even with the latest patches, rmmod'ing the rt2xXXX stuff causes a complete system freeze. Unless I bring down the interface first via 'ifconfig wlanX down', unloading the driver while operational equates OS hang and hard reset.

Odd I have been testing this while stresstesting the card, and either
unplugging, rmmod or ifdown, and I couldn't
reproduce any crashes. Has the stacktrace changed after these patches?

Ivo
