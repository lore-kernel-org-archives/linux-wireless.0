Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39609 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbZKXKws (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 05:52:48 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de, oncaphillis@snafu.de
Subject: Re: [PATCH RFC] ssb: Generic SPROM override for devices without SPROM
Date: Tue, 24 Nov 2009 11:52:49 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200911201212.19588.mb@bu3sch.de> <4B0B9E99.1060201@snafu.de>
In-Reply-To: <4B0B9E99.1060201@snafu.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911241152.51787.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 24 November 2009 09:51:37 Oncaphillis wrote:
> On 11/20/2009 12:12 PM, Michael Buesch wrote:
> > This patch adds a generic mechanism for overriding the SPROM mechanism
> > on devices without SPROM hardware.
> >
> > There currently is a major problem with this:
> > It tries to deduce a MAC address from various hardware parameters. But
> > currently it will result in the same MAC address for machines of the same
> > type. Does somebody have an idea of some device-instance specific serial
> > number or something similar that could be hashed into the MAC?
> >
> What version is this patch against ? I tries rc7,rc8 and 2.6.31.6.
> But it doesn't work for me.

wireless testing

-- 
Greetings, Michael.
