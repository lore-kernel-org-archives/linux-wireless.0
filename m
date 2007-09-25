Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51410.mail.re2.yahoo.com ([206.190.38.189]:26292 "HELO
	web51410.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751248AbXIYOnf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 10:43:35 -0400
Date: Tue, 25 Sep 2007 07:43:32 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: API to regulatory control (1)
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <923504.45912.qm@web51410.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 > From what I can see, this finishes the channel restrictions API. Since
 > none of the information in the channels list is specific to some device,
 > it may be allocated statically.

Well, I beg to differ. I'm working on a system were we have regulatory
approval to use a TX power of up to 4W in certain channels. This means
that the regulatory settings (e.g. allowed channels) are different for
cards with amplifier and those without, even on the same machine.
--  Regards
 
       Joerg
 






      __________________________________  
Yahoo! Clever: Sie haben Fragen? Yahoo! Nutzer antworten Ihnen. www.yahoo.de/clever

