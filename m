Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:24191 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899AbZGQGF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 02:05:56 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org, Joel Roth <joelz@pobox.com>
Subject: Re: ath5k and Atheros AR242x - No scan results
Date: Fri, 17 Jul 2009 08:06:23 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>
References: <20090630170916.GB5137@sprite> <1247734019.19467.0.camel@johannes.local> <20090716100743.GC3867@sprite>
In-Reply-To: <20090716100743.GC3867@sprite>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907170806.23728.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 1. kernel and driver setup - use compat-wireless
>
> 2. set wireless interface to UP
>
> 	ifconfig <interface> up
>
> 3. find available networks using
>
> 	iw dev <interface> scan
>  or
> 	iwlist <interface> scan

And maybe here the tools could emit "interface <interface> isn't 
up" as a more specfic error message ?!?

-- 
http://www.holgerschurig.de
