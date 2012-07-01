Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:3146 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932358Ab2GANgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 09:36:15 -0400
Message-ID: <1341149770.1911.101.camel@x61.thuisdomein> (sfid-20120701_153618_890965_07AF1354)
Subject: RE: [RFT] iwlegacy: don't mess up the SCD when removing a key
From: Paul Bolle <pebolle@tiscali.nl>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Sun, 01 Jul 2012 15:36:10 +0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB317245E@HASMSX103.ger.corp.intel.com>
References: <1341148023-17673-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1341144092.1911.95.camel@x61.thuisdomein>
	 <0BA3FCBA62E2DC44AF3030971E174FB317245E@HASMSX103.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel,

On Sun, 2012-07-01 at 13:29 +0000, Grumbach, Emmanuel wrote:
> You can also try to simply associate / disassociate in a loop with and
> without my patch. This was the scenario that was fixed by my patch in
> iwlwifi.

I'm actually unfamiliar with associating and disassociating. How can I
do that in a loop?


Paul Bolle

