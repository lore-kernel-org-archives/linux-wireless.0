Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51514 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYEVTEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 15:04:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [PATCH] mac80211: do not alter injected seq numbers
Date: Thu, 22 May 2008 21:03:39 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	JMF <tolas_feup@hotmail.com>,
	"Alejandro Grijalba =?iso-8859-1?q?Mart=EDnez?=" <sud@latinsud.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John Linville" <linville@tuxdriver.com>
References: <47FAB829.9010304@latinsud.com> <1211481278.3698.58.camel@johannes.berg> <69e28c910805221152g199d83b9s225799d0e3e53bcd@mail.gmail.com>
In-Reply-To: <69e28c910805221152g199d83b9s225799d0e3e53bcd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200805222103.39689.mb@bu3sch.de> (sfid-20080522_210411_991687_C90F59D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 22 May 2008 20:52:21 Stefanik G=E1bor wrote:
> On Thu, May 22, 2008 at 8:34 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >> >> This does not work, since we use injection for other types of
> >> >>  frames. For example management frames from hostapd. We don't w=
ant
> >> >>  (and can't) make hostapd keep track of sequence numbers.
> >> >> You'll have to contact radiotap people and add a flag for this.
> >> >>  This would also solve the hardware counter problem then.
> >
> >> The flag is IEEE80211_TX_INJECTED. Here is a new patch, for the
> >> current wireless-testing:
> >
> > Reorder the two blocks and you have your answer. NO.
> >
> > johannes
> >
>=20
> Hmm, shouldn't this version fix the hostap and other non-monitor-mode=
 cases?

No.
Hostapd is _not_ a non-monitor-case.

--=20
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
