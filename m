Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63969 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1F3LCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 07:02:52 -0400
Received: by qwk3 with SMTP id 3so1043546qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 04:02:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308755270.21489.YahooMailRC@web161204.mail.bf1.yahoo.com>
References: <loom.20110621T215346-191@post.gmane.org>
	<BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com>
	<1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com>
	<1308750416.29571.10.camel@jlt3.sipsolutions.net>
	<1308753669.17439.YahooMailRC@web161208.mail.bf1.yahoo.com>
	<1308754204.29571.15.camel@jlt3.sipsolutions.net>
	<1308755270.21489.YahooMailRC@web161204.mail.bf1.yahoo.com>
Date: Thu, 30 Jun 2011 07:02:51 -0400
Message-ID: <BANLkTi=Ob1H7XdG5-21SnjkuyVF9xw+xBA@mail.gmail.com> (sfid-20110630_130255_864573_1432DC10)
Subject: Re: [ath5k-devel] Performance regression between Madwifi/net80211 and ath5k/mac80211
From: Bob Copeland <me@bobcopeland.com>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 22, 2011 at 11:07 AM, Joerg Pommnitz <pommnitz@yahoo.com> wrote:
>> I guess you'll  need more help from the HW people here.
>
> Bob, Bruno, Felix, Luis, Nick: Do you read?

I guess I would be interested to know if there are any obvious
differences in the streams. E.g. taking a monitor mode capture
near the receiver should show whether the received power is similar,
whether the # of retransmissions is significantly higher in ath5k
vs madwifi, whether packets are sent at the same bitrates, if there
are any pauses where ath5k doesn't seem to be doing anything, etc.

Would it be possible to do a few captures with your setup?
-- 
Bob Copeland %% www.bobcopeland.com
