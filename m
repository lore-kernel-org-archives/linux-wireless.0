Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbXINSNB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 14:13:01 -0400
Subject: Re: iwlist and network-manager bug report
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: jt@hpl.hp.com, linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1189707493.1329.1.camel@johannes.berg>
References: <1189526874.6161.30.camel@johannes.berg>
	 <1189610572.5644.28.camel@xo-3E-67-34.localdomain>
	 <20070912170153.GA25785@bougret.hpl.hp.com>
	 <1189667496.6161.77.camel@johannes.berg>
	 <1189707493.1329.1.camel@johannes.berg>
Content-Type: text/plain; charset=utf-8
Date: Fri, 14 Sep 2007 14:09:40 -0400
Message-Id: <1189793380.2508.2.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-09-13 at 20:18 +0200, Johannes Berg wrote:
> On Thu, 2007-09-13 at 09:11 +0200, Johannes Berg wrote:
>=20
> > Ok. I'll have to do some more extensive tests but in my last test w=
ith
> > zd1211 it wouldn't display anything. Might be a different issue, bu=
t
> > scanning manually showed things.
>=20
> Cool, I was totally wrong, seems the fact that it didn't display
> anything was unrelated. I just tried again and NM 0.6.5 as shipped by
> debian/unstable actually manages to display the =C3=BC umlaut that is
> supposed to be the \xfc character.
>=20
> Btw. Will there ever be a 0.7 release? :)

I've been burning the midnight oil on it for the past few weeks, check
NM and applet changelogs.  Still not quite there yet, there's some core
work left to do getting NM to talk to the settings daemons (ie,
nm-client or knetworkmanager) correctly, getting GUI bits for Connectio=
n
editing in the applet, and making sure the relevant settings are
honored.

Dan


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
