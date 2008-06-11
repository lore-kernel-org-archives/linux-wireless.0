Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51403.mail.re2.yahoo.com ([206.190.38.182]:26236 "HELO
	web51403.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752082AbYFKIer convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 04:34:47 -0400
Date: Wed, 11 Jun 2008 01:28:05 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Reply-To: pommnitz@yahoo.com
Subject: RE: [RFC] First CRDA integration work
To: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <951547.47167.qm@web51403.mail.re2.yahoo.com> (sfid-20080611_103452_860407_797665AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luis,
I did not read the complete patch but closely looked at the CRDA design picture. I have a comment:
The company I work for has special regulatory approval to use amplified WLAN on certain channels (up to 4W). The nodes additionally have non-amplified WLAN adapters that fall under the normal regulatory requirements. It would be nice if your work allowed to specify such cases, e.g. have different regulatory restrictions for differen cards in the same machine. In our case we would like to restrict the amplified interface to the channels it is allowed to run on.

-- 
Regards
       Joerg


      __________________________________________________________
Gesendet von Yahoo! Mail.
Dem pfiffigeren Posteingang.
http://de.overview.mail.yahoo.com
