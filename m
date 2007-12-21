Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:34685 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbXLUM6Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 07:58:16 -0500
From: Andreas Schwab <schwab@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: remove useless sdata variable
References: <1198195385.16241.68.camel@johannes.berg>
	<je63ysp7ua.fsf@sykes.suse.de>
	<1198240471.16241.70.camel@johannes.berg>
Date: Fri, 21 Dec 2007 13:58:14 +0100
In-Reply-To: <1198240471.16241.70.camel@johannes.berg> (Johannes Berg's
	message of "Fri\, 21 Dec 2007 13\:34\:31 +0100")
Message-ID: <je1w9gp5ll.fsf@sykes.suse.de> (sfid-20071221_125821_386536_7BEE82F8)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Perhaps because it is used?
>>=20
>> > --- everything.orig/net/mac80211/ieee80211_sta.c	2007-12-21 01:02:=
11.253160428 +0100
>> > +++ everything/net/mac80211/ieee80211_sta.c	2007-12-21 01:02:32.11=
3165907 +0100
>> > @@ -458,12 +458,10 @@ static void ieee80211_set_associated(str
>> >  		return;
>> > =20
>> >  	if (assoc) {
>> > -		struct ieee80211_sub_if_data *sdata;
>
> Too little context. There's another one in the surrounding scope that=
 is
> already initialised exactly the same.

Sorry, but I can't find it.  Was it added in an unmerged patch?

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
