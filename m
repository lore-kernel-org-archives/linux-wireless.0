Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:46778 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbYIPJ0A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 05:26:00 -0400
From: Helmut Schaa <hschaa@suse.de>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
Date: Tue, 16 Sep 2008 11:25:57 +0200
Cc: Kalle Valo <kalle.valo@nokia.com>,
	"Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200809151416.07552.hschaa@suse.de> <87fxo0zee1.fsf@nokia.com> <200809161050.41482.hs4233@mail.mn-solutions.de>
In-Reply-To: <200809161050.41482.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809161125.57593.hschaa@suse.de> (sfid-20080916_112605_438146_30F5536C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 16. September 2008 10:50:41 schrieb Holger Schurig:
> That would mean that you can use the Quality still for a
> decision "Should I do a background scan or not?". But you cannot
> use it for a decision "Should I switch to this AP or not?".

Agreed. After the scan was triggered (based on whatever indicators) the 
decision is up to the supplicant once the scan results arrive. AFAIK it 
currently uses max_rate, signal_level and signal_quality (beside the security 
flags when multiple networks are defined).

Helmut
