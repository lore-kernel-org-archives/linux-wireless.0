Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35824 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbcAMH6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 02:58:08 -0500
Received: by mail-oi0-f53.google.com with SMTP id p187so71285383oia.2
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2016 23:58:07 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 13 Jan 2016 08:58:07 +0100
Message-ID: <CACZXzRCSnc_5vTBRVpX7Z1eY8JtAeeOux_UQknbRCvj5ysbAFQ@mail.gmail.com> (sfid-20160113_085813_855380_BD3C4A26)
Subject: Advice about otherbss monitor flag for Wireshark use
From: Mikael Kanstrup <mikael.kanstrup@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Roger James reported that capturing wireless data on monitor
interfaces created by Wireshark only capture frames to/from BSSID of
the monitor interface. This was solved using iw by setting otherbss
monitor flag. See Wireshark mailing list thread here:
https://www.wireshark.org/lists/wireshark-dev/201601/msg00031.html

I suggested a patch to handle this within Wireshark:
https://code.wireshark.org/review/#/c/13219

Now before merging I hope to get some feedback here if this is safe
for the general case? For most users/drivers it appears explicitly
setting the flag is not needed.

/Mikael
