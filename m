Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51403.mail.re2.yahoo.com ([206.190.38.182]:35567 "HELO
	web51403.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763407AbZD3NsS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 09:48:18 -0400
Message-ID: <557754.25367.qm@web51403.mail.re2.yahoo.com>
Date: Thu, 30 Apr 2009 06:41:36 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: rt73usb Access point status
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Based on that information, I have removed the "Yes (under development)"
> note from the driver page since it doesn't really support it... In fact,
> I'm surprised it works even with that hack since hostapd usually polls
> the station with nullfunc frames and waits for an ack.

Reading the mail from Ivo (http://sourceforge.net/mailarchive/message.php?msg_id=200808082059.11968.IvDoorn%40gmail.com)
I gather that the ACK in question is not from the peer but from the local
hardware indicating that the frame was actually sent and not lost due to
some local error. 
-- 
Regards 
Joerg 


      
