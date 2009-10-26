Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:30262 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZJZOai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 10:30:38 -0400
From: Holger Schurig <h.schurig@mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RECAP: indication of channel noise
Date: Mon, 26 Oct 2009 15:30:03 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
References: <200910261442.44774.h.schurig@mn-solutions.de> <1256565132.12462.9.camel@johannes.local>
In-Reply-To: <1256565132.12462.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910261530.03422.h.schurig@mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >   NL80211_BSS_NOISE_MBM

Hmm, this could better be NL80211_CHANNEL_NOISE_MBM, to make
clear that this is not heat-related internal noise of the chip.



For the rest of your remarks: ok


-- 
M&N Solutions GmbH          Ein Unternehmen der Datagroup AG
Holger Schurig
Raiffeisenstr. 10
61191 Rosbach
Tel: 06003/9141-15          Fax 06003/9141-49
http://www.mn-solutions.de/

Handelsregister Friedberg, HRB 5903
Geschäftsführer: P.Schrittenlocher
