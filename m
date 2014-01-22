Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59513 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaAVTJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 14:09:20 -0500
Received: by mail-ie0-f172.google.com with SMTP id e14so12198822iej.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 11:09:20 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 22 Jan 2014 14:09:20 -0500
Message-ID: <CAKKnJbdK1eJJoFZik1SENg1PtnqMsK=B4mEtoausGybKNywSqw@mail.gmail.com> (sfid-20140122_200934_725598_D0D2072F)
Subject: wl12xx force lower bitrate
From: Charles <hobbesc7@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using the wl12xx-spi driver with a TI wl1271 chipset.  In my
application, range is more important than throughput, so I want to
force a lower bitrate (like 802.11b speeds at the fastest.)

None of the commands for doing this seem to have any effect, however.
I've tried both iwconfig and iw.

Is forcing a lower bitrate possible with this driver / firmware / chipset?
