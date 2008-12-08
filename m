Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:29561 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYLHQeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 11:34:19 -0500
Received: by nf-out-0910.google.com with SMTP id d3so582419nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 08:34:17 -0800 (PST)
To: "Lars Ericsson" <Lars_Ericsson@telia.com>
Subject: Re: Monitor number of packages sent and ACK'ed by AP
Date: Mon, 8 Dec 2008 17:34:14 +0100
Cc: "'Johannes Berg'" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <2302AE261F8F40829ECF8CCCB6DD612B@gotws1589>
In-Reply-To: <2302AE261F8F40829ECF8CCCB6DD612B@gotws1589>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812081734.14920.IvDoorn@gmail.com> (sfid-20081208_173422_917069_8391DA88)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 December 2008, Lars Ericsson wrote:
> > 
> > On Mon, 2008-12-08 at 11:50 +0100, Lars Ericsson wrote:
> > > Hi Johannes,
> > > 
> > > I would like to monitor number of packages properly 
> > transmitted and ACK'ed
> > > by the AP.
> > > Is the a single point where this can be done ?
> > 
> > Not really, some drivers don't even give you that information,
> > unfortunately.
> > 
> > johannes
> > 
> 
> OK, thanks. 
> I just discovered that Ralink rt61 does filter all ACK frames.
> /Lars

Did you look during monitor mode?
When monitor mode is not enabled, the RX filter can be quite strict.

Ivo
