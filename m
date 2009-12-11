Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:60916 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875AbZLKPk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 10:40:27 -0500
Received: by fxm21 with SMTP id 21so1138015fxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2009 07:40:33 -0800 (PST)
From: Holger Schurig <holgerschurig@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Switching channel in IBSS network doesn't work in ath9k
Date: Fri, 11 Dec 2009 17:39:55 +0100
Cc: Holger Schurig <holgerschurig@googlemail.com>,
	Joerg Pommnitz <pommnitz@yahoo.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
References: <500577.32161.qm@web51405.mail.re2.yahoo.com> <200912101846.40572.holgerschurig@gmail.com> <43e72e890912100914m1766db5fife6563fec3807b8d@mail.gmail.com>
In-Reply-To: <43e72e890912100914m1766db5fife6563fec3807b8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200912111739.55225.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Actually I think a simple 'iw link' to do this for all interfaces
> would be good. I just haven't gotten around to it. I should be
> possible without upstream changes I believe.

Do you think that "iw link" should also show then info when the device is in 
monitor mode (e.g. return the flags) or in IBSS mode?  And probably also 
reporting parts of the survey data, e.g. noise floor?

That would be the equivalent of a "give me the greatest amount of info 
quickly" :-)

-- 
http://www.holgerschurig.de
