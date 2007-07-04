Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51401.mail.re2.yahoo.com ([206.190.38.180]:33468 "HELO
	web51401.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754032AbXGDHlu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2007 03:41:50 -0400
Date: Wed, 4 Jul 2007 00:41:49 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: AW: [WIP] mac80211: kill mgmt interface
To: Tomas Winkler <tomasw@gmail.com>, Jiri Benc <jbenc@suse.cz>
Cc: "Cohen, Guy" <guy.cohen@intel.com>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <699262.29475.qm@web51401.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> wrote:
> There is probably difference between running multiple hostapd
> instances and running in multiple BSSID mode over one interface,
> meaning that hostapad is running multiple instances of MLME. I guess
> the original post was a bit confusing.
> I'm not sure if and how current implementation of hostapd can do that,
> but that's probably question for another mailing list.

What triggered my initial mail was the concern that I did not see how
one monitor interface could be used to control multiple AP interfaces.
Obviously there must be a link that allows the MLME to associate
frames that it receives from the monitor IF to a specific AP interface.

I wanted to make sure that the API provides such an association. If
this is already the case, my point is mute and I will go back to lurking.
 
--  
Regards
 
       Joerg




      __________________________________  Alles was der Gesundheit und Entspannung dient. BE A BETTER MEDIZINMANN! www.yahoo.de/clever
