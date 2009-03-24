Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:50642 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370AbZCXUDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 16:03:17 -0400
Received: by qyk16 with SMTP id 16so3631001qyk.33
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 13:03:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090324184100.GA29268@tesla>
References: <200903241938.47155.chunkeey@web.de>
	 <b6c5339f0903241159x505fc88ap4d9850fa74733156@mail.gmail.com>
	 <20090324184100.GA29268@tesla>
Date: Tue, 24 Mar 2009 16:03:14 -0400
Message-ID: <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com> (sfid-20090324_210320_758134_AACBDA0E)
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 2:41 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Do any of you guys have time to pick it up?

Well my patch #2 is pretty similar to what Christian has, and I'd like to
upstream the first few patches soon (especially the ath.ko creation, it is a
beast to rebase as you saw).  That would bring up the first contentious
point of the merge: is "ath/ath.ko" ok with everyone?  ath5k/9k specific
bits can eventually go in ath/{5k,9k} subdirs... not sure where 9170
lives then :)

I probably can't get to it until the weekend, but if you have more time,
Christian, feel free to adopt whatever you want from mine.  Otherwise I'll
pick up where Luis left off on the weekend.

I didn't push it yet because ath5k was having problems once I turned it
on for ath5k, and I have no other hardware to test with so wanted to
figure out what was broken first.  Channel list is a good hint, maybe
it's time to fix iw/nl80211 to send back all the channels :)

-- 
Bob Copeland %% www.bobcopeland.com
