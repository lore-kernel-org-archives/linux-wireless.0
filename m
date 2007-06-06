Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51404.mail.re2.yahoo.com ([206.190.38.183]:29381 "HELO
	web51404.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755745AbXFFKAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2007 06:00:20 -0400
Date: Wed, 6 Jun 2007 03:00:18 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: RE: RFC: Regulatory info in mac80211
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <645600.8486.qm@web51404.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:



> 1. The regulatory information is too dynamic to be placed in the kernel.



And not all regulatory information is public: as I wrote in a previous message:

I work for a company that has special regulatory permission to use channels

outside those freely available with tx power of up to 4W. This is a legitimate

use case that should not be forbidden by a new regdomain framework (I can always

hack around this, but that's just a hack, not a clean solution).



Regarding a user space daemon: keep in mind special use cases like NFSroot over WLAN.



> 2. The regulatory database should be in an ASCII file for easy updating. This database should be 

> read by a userspace daemon that reformats the information and supplies it to mac80211 upon demand.



OK.



> 3. There should be some sort of checking to verify that the database has not been hacked to modify 

> transmission power, etc. in an illegal manner. Obviously, no foolproof means of enforcing this does 

> not exist; however, we should prevent the crudest form of modifications.

Define "illegal manner". For me it is perfectly legal to use channel 14 in Europe with 4W tx power. I admit that this is a

special interest, but nonetheless perfectly legal.





--  

Regards

 

       Joerg

 











       __________________________________ Yahoo! Clever - Der einfachste Weg, Fragen zu stellen und Wissenswertes mit Anderen zu teilen. www.yahoo.de/clever

