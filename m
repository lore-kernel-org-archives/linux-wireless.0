Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965400Ab2EQLF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 07:05:26 -0400
Message-ID: <1337252722.4332.1.camel@jlt3.sipsolutions.net> (sfid-20120517_130529_871496_5F3D4CCE)
Subject: Re: [PATCH] mac80211: add op to configure default key id to driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Ravi Sharma <sharmaravi.lx@gmail.com>
Cc: "Divinsky, Yonatan" <yoni.divinsky@ti.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 17 May 2012 13:05:22 +0200
In-Reply-To: <CAEZZmbF6wa3JF48KsCiyg4T7OsBS73OnzAMVYPkPdPro9EYUtg@mail.gmail.com> (sfid-20120517_103653_559210_BF230AEA)
References: <1336479518-23006-1-git-send-email-yoni.divinsky@ti.com>
	 <1336485961.4320.1.camel@jlt3.sipsolutions.net>
	 <CANJm+iAoVkPOO61ufrM3mxzsURFZzuNcMm9N6Y=3xUbSCaC1+w@mail.gmail.com>
	 <1337072920.4546.0.camel@jlt3.sipsolutions.net>
	 <CANJm+iDif1+KREB=CJ_wYbo+Hzxo=nJL6fUxbBTQ5_C8Tz0E9Q@mail.gmail.com>
	 <CANJm+iDU1ahy3B9u6nn=0E4d0Pge+OubaNE9bPaE1EXYGahOUA@mail.gmail.com>
	 <CAEZZmbEExFr6=7G6kQb_bbpt=wfiNDuoR+U4_Eu_wLdair=SrA@mail.gmail.com>
	 <CAEZZmbF6wa3JF48KsCiyg4T7OsBS73OnzAMVYPkPdPro9EYUtg@mail.gmail.com>
	 (sfid-20120517_103653_559210_BF230AEA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-17 at 14:06 +0530, Ravi Sharma wrote:
> Hi All
> I know this use case is quite trivial looking regarding WEP (Since it
> is going to be deprecated), we faced a issue with minap (softap) in
> WEP security with auth mode as shared. Since the default key is not
> passed to driver, we can not program firmware default key idx (default
> key is programmed when data packet exchange started, looking into type
> of encryption) and the handshake failed in shared auth mode. In open
> mode, there is no need for this.

Now you're talking about something else entirely? What does this have to
do with auto-ARP responses??

Can we get that story straight? :-) And then a patch that actually
explains & documents it ... Remember that the changelog should indicate
why you're changing something.

johannes

