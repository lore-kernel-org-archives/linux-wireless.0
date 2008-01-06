Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:1695 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbYAFS0C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 13:26:02 -0500
Received: by fg-out-1718.google.com with SMTP id e21so4096177fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 10:26:01 -0800 (PST)
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] mac80211: Add radio led trigger
Date: Sun, 6 Jan 2008 19:25:44 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200801061410.12862.IvDoorn@gmail.com> <1ba2fa240801061019w2cc28082s9084c00a5d14f810@mail.gmail.com>
In-Reply-To: <1ba2fa240801061019w2cc28082s9084c00a5d14f810@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801061925.44484.IvDoorn@gmail.com> (sfid-20080106_182607_797242_3A66182D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 06 January 2008, Tomas Winkler wrote:
> On Jan 6, 2008 3:10 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > Some devices have a seperate LED which indicates if the radio is
> > enabled or not. This adds a LED trigger to mac80211 where drivers
> > can hook into when they are interested in radio status changes.
> >
> >
> I wonder how this go together with RF KILL led?

They would be competing I fear, but not all devices have a rfkill button,
which makes the mac80211 radio led trigger more usefull I think.

Ivo
