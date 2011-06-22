Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34137 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595Ab1FVSxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 14:53:16 -0400
Received: by iyb12 with SMTP id 12so906877iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 11:53:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308755270.21489.YahooMailRC@web161204.mail.bf1.yahoo.com>
References: <loom.20110621T215346-191@post.gmane.org> <BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com>
 <1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com>
 <1308750416.29571.10.camel@jlt3.sipsolutions.net> <1308753669.17439.YahooMailRC@web161208.mail.bf1.yahoo.com>
 <1308754204.29571.15.camel@jlt3.sipsolutions.net> <1308755270.21489.YahooMailRC@web161204.mail.bf1.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Jun 2011 11:52:55 -0700
Message-ID: <BANLkTim=NOgrpPh_iW5pkBi925yhH+NSrw@mail.gmail.com> (sfid-20110622_205319_898381_84E3CCC8)
Subject: Re: Performance regression between Madwifi/net80211 and ath5k/mac80211
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 22, 2011 at 8:07 AM, Joerg Pommnitz <pommnitz@yahoo.com> wrote:
>> I guess you'll  need more help from the HW people here.
>
> Bob, Bruno, Felix, Luis, Nick: Do you read?

I read but I do not have time to work on this, my focus is on newer
hardware and other things. Only thing I can recommend is to stay with
the latest drivers [1] for your metrics, and if you choose a stable
release instead of bleeding edge pick the latest stable [2]. You may
want to try Oprofile to see where ath5k spends its time doing most
work.

[1] http://wireless.kernel.org/en/users/Download
[2] http://wireless.kernel.org/en/users/Download/stable

  Luis
