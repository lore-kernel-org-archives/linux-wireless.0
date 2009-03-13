Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63349 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbZCMDSX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 23:18:23 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 20:18:22 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18873.53124.115355.862512@gargle.gargle.HOWL> (sfid-20090313_041826_782104_8E8490E6)
Date: Fri, 13 Mar 2009 08:44:12 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Which APs to disregards from in inputting into the bss list
In-Reply-To: <43e72e890903122009h25c7f6d9qcf4365ec32532e31@mail.gmail.com>
References: <43e72e890903122009h25c7f6d9qcf4365ec32532e31@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Do we want to ignore certain APs if we determine they are bogus? An
> example is 11n APs with WEP/TKIP. 

They are not bogus, we just fall back to legacy association.

Sujtih
