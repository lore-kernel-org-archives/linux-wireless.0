Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:39486 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbZEBKSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 06:18:47 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1M0CIt-0002CE-AU
	for linux-wireless@vger.kernel.org; Sat, 02 May 2009 10:18:43 +0000
Received: from cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com ([82.16.102.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 02 May 2009 10:18:43 +0000
Received: from jon.fairbairn by cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 02 May 2009 10:18:43 +0000
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: rt73usb Access point status
Date: Sat, 02 May 2009 11:18:29 +0100
Message-ID: <wfk54zu7t6.fsf@calligramme.charmers>
References: <557754.25367.qm@web51403.mail.re2.yahoo.com> <efe7343f0904300656g127e83e1ge0b21060d6a69955@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Luis Correia
<luis.f.correia@gmail.com>
writes:

Hi Luis; thanks for your replies... more below:

> On Thu, Apr 30, 2009 at 14:41, Joerg Pommnitz <pommnitz@yahoo.com> wr=
ote:
>> Reading the mail from Ivo
>> (http://sourceforge.net/mailarchive/message.php?msg_id=3D20080808205=
9.11968.IvDoorn%40gmail.com)

I found that before I posted and found it discouraging,
hence the question.

>> I gather that the ACK in question is not from the peer but from the =
local
>> hardware indicating that the frame was actually sent and not lost du=
e to
>> some local error.
>
> According to Ivo, we cannot be totally sure that the device has sent
> the frame into the air, so no actual ACK is reported back to mac80211=
=2E
>
> The hostapd hack works, as long as the stations are not very far from
> the AP, and thus not 'too many retries' need to be sent.

So is the bug really in hostapd?

> AFAIK, this is not optimal at all, so I don't go around and say 'it
> works'. It may or may not work in your case.

Since I would want to make an AP that generally worked, I
don't think it would be enough.

> If possible, test and report back your findings.

I don't currently have a dongle. I'd be happy to buy one and
test it (I really don't mind going through a fair number of
patch/test/report back cycles, it's just writing code that's
not currently something I can do), but not if there's a
demarcation dispute as to who owns the bug!

--=20
J=C3=B3n Fairbairn                                 Jon.Fairbairn@cl.cam=
=2Eac.uk


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
