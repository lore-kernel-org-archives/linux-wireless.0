Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.216.179]:55144 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZJAUT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 16:19:58 -0400
MIME-Version: 1.0
In-Reply-To: <20091001170722.GC2895@tuxdriver.com>
References: <20090924180048.14503.9579.stgit@tikku> <43e72e890909241320j592e347die8a14f8bdd962ffb@mail.gmail.com>
	<20090925044258.GA2722@tuxdriver.com> <da94abde0909250947k5084db85vccafe0d3e74e2ecf@mail.gmail.com>
	<43e72e890909250953r1714c79bsa679b96ca6f5797@mail.gmail.com>
	<20091001011340.GA3123@tuxdriver.com> <87fxa3qjt2.fsf@purkki.valot.fi>
	<20091001151820.GA2895@tuxdriver.com> <873a63qe6e.fsf@purkki.valot.fi>
	<20091001170722.GC2895@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 1 Oct 2009 19:56:40 +0000
Message-ID: <43e72e890910011256v18b30e7ck420ce80b5d35fdcb@mail.gmail.com>
Subject: Re: [PATCH 0/2] cfg80211: firmware and hardware version
To: "John W. Linville" <linville@tuxdriver.com>,
	"Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 1, 2009 at 5:07 PM, John W. Linville <linville@tuxdriver.com> wrote:

> I don't predict a huge problem if there are
> valid extensions required for use by wireless drivers in the future.
> But for now, I'd like to see us make use of some of the debugging
> facilities available in the ethtool API -- hopefully the iwlwifi guys
> are listening... ;-)

Does the same apply to wimax then? Ethtool for 802.11 and wimax? Eh.

  Luis
