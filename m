Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44232 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1AXHrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 02:47:06 -0500
Received: by eye27 with SMTP id 27so1714209eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jan 2011 23:47:04 -0800 (PST)
Date: Mon, 24 Jan 2011 10:46:59 +0300
From: Paul Fertser <fercerpav@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Thomas d'Otreppe" <tdotreppe@gmail.com>,
	Richard Farina <sidhayn@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [RFC][PATCH] cfg80211: report monitor interface channel via
	wext when possible
Message-ID: <20110124074659.GD25136@home.lan>
References: <1295655098-17534-1-git-send-email-fercerpav@gmail.com> <1295773599.3639.4.camel@jlt3.sipsolutions.net> <201101241010.38393.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201101241010.38393.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 24, 2011 at 10:10:38AM +0900, Bruno Randolf wrote:
> On Sun January 23 2011 18:06:39 Johannes Berg wrote:
> > On Sat, 2011-01-22 at 03:11 +0300, Paul Fertser wrote:
> > > This makes it possible to retrieve the channel for the monitor interface
> > > in cases when it can be determined unambigously. Tested with ath5k.
> > 
> > NAK.
> > 
> > http://article.gmane.org/gmane.linux.kernel.wireless.general/61860
> 
> > I don't think so -- I don't recall anyone ever asking before ;-)
> 
> I definetly want this functionality for my WLAN monitoring tool ("horst" - 
> http://br1.einfach.org/horst). 

You took the quote out of the context :), Johannes meant that nobody
has asked him how exactly he would like to see this functionality
implemented, and the in the linked mail he outlines his proposal.

Johannes, i know you're a busy man (no kidding, i understand you're
doing serious work) and users should trust maintainers on their
technical decisions, but i hope you can still spare a minute to
explain me why my proposed way to use set_channel is wrong (as i'm yet
to see any drawbacks). Working with real professionals like you is a
great opportunity for me to learn and i appreciate it a lot.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
