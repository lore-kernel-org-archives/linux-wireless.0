Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:60493 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3LaEZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Dec 2013 23:25:03 -0500
Received: by mail-ob0-f172.google.com with SMTP id gq1so12318958obb.17
        for <linux-wireless@vger.kernel.org>; Mon, 30 Dec 2013 20:25:02 -0800 (PST)
MIME-Version: 1.0
From: Pierre Bourdon <delroth@gmail.com>
Date: Tue, 31 Dec 2013 05:24:42 +0100
Message-ID: <CA+V6dmh7Udn96GG0XGaabx-t6ZViu1RGk-xTawa_KbnCdro9Ew@mail.gmail.com> (sfid-20131231_052532_890939_E8ECD40B)
Subject: Exporting the TSF to userland
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello linux-wireless,

I'm a developer of libdrc, a project that allows Linux computers to
control a Wii U GamePad. Because of how the device operates, our
library needs to be able to read the TSF value of the access point
device from userland.

We currently have a hacky patch that works for our use cases, but it
would be a lot more convenient if that feature could be upstreamed.
What would be the best way to proceed?

Our current patch:
https://bitbucket.org/memahaxx/drc-mac80211/commits/4a9823cf2a6733bc15a05cffaebd8850d07451a7

Thanks,

-- 
Pierre "delroth" Bourdon <delroth@gmail.com>
Software Engineer @ Zürich, Switzerland
http://code.delroth.net/
