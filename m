Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:47819 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbYAFSXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 13:23:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] mac80211: Add radio led trigger
Date: Sun, 6 Jan 2008 19:22:36 +0100
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200801061410.12862.IvDoorn@gmail.com> <1ba2fa240801061019w2cc28082s9084c00a5d14f810@mail.gmail.com>
In-Reply-To: <1ba2fa240801061019w2cc28082s9084c00a5d14f810@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801061922.37122.mb@bu3sch.de> (sfid-20080106_182343_567205_87AA4DB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 06 January 2008 19:19:54 Tomas Winkler wrote:
> On Jan 6, 2008 3:10 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > Some devices have a seperate LED which indicates if the radio is
> > enabled or not. This adds a LED trigger to mac80211 where drivers
> > can hook into when they are interested in radio status changes.
> >
> >
> I wonder how this go together with RF KILL led?

The rfkill LED is a seperate LED.
This LED is the software status of the radio. Not too useful, but hey. :)

-- 
Greetings Michael.
