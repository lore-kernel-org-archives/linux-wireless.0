Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:12562 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZI1PII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 11:08:08 -0400
From: Holger Schurig <h.schurig@mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] libertas: first stab at cfg80211 support
Date: Mon, 28 Sep 2009 17:07:59 +0200
Cc: libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
References: <200909281321.21600.h.schurig@mn-solutions.de> <200909281654.08859.h.schurig@mn-solutions.de> <1254149857.3151.5.camel@johannes.local>
In-Reply-To: <1254149857.3151.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909281707.59846.h.schurig@mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It might make sense to support adding interfaces with nl80211,
> since apparently it has mesh and monitor interfaces.

Yes, this will eventually be added.


In the end I'd like to have all WEXT code in it's own file or 
#ifdef'd and I'd like to have a working libertas_cs and 
libertas_usb that don't need WEXT at all. But that will take 
considerable time :-)   One step towards this goal will be 
monitor mode via NL80211.

Mesh-support via NL80211 must be done by someone else, I don't 
have neither the knowledge, mesh nodes nor a mesh-capable 
firmware. And I don't really care about mesh. So if no one else 
does it, the CFG80211-only libertas-driver won't have mesh at 
all.

-- 
M&N Solutions GmbH          Ein Unternehmen der Datagroup AG
Holger Schurig
Raiffeisenstr. 10
61191 Rosbach
Tel: 06003/9141-15          Fax 06003/9141-49
http://www.mn-solutions.de/

Handelsregister Friedberg, HRB 5903
Geschäftsführer: P.Schrittenlocher
