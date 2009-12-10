Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:46482 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402AbZLJROQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 12:14:16 -0500
Received: by iwn1 with SMTP id 1so5509280iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2009 09:14:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200912101846.40572.holgerschurig@gmail.com>
References: <500577.32161.qm@web51405.mail.re2.yahoo.com> <200912101846.40572.holgerschurig@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 10 Dec 2009 09:14:01 -0800
Message-ID: <43e72e890912100914m1766db5fife6563fec3807b8d@mail.gmail.com>
Subject: Re: Switching channel in IBSS network doesn't work in ath9k
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: Joerg Pommnitz <pommnitz@yahoo.com>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 10, 2009 at 9:46 AM, Holger Schurig
<holgerschurig@googlemail.com> wrote:
>> P.S.: Is there a way to get an overview of the current interface
>>  configuration with iw? What is the equivalent of "iwconfig wlan0"?
>
> There's none. Currently, iw iw written almost like a direct representation
> of cfg80211 commands. For things like "iw link", the code has added a bit of
> magic, so that this actually sends two cfg80211 command. But in general,
> it's a 1:1 relation.
>
> So, you'd need to write some "give me greatest amount of info" command newly
> for iw.

Actually I think a simple 'iw link' to do this for all interfaces
would be good. I just haven't gotten around to it. I should be
possible without upstream changes I believe.

  Luis
