Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:30558
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230Ab2GXDoE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 23:44:04 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: [PATCH v2] mac80211: VHT (11ac) Association
Date: Tue, 24 Jul 2012 03:44:01 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC6FE7@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120724_054409_035472_2DF7F245)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC6FCB@mbx022-e1-nj-10.exch022.domain.local>,<CAGRGNgVGfXxyPWPs=0gwFnWbAG5oLkrZ5jsO5Q_w1VOV1W2CPQ@mail.gmail.com>
In-Reply-To: <CAGRGNgVGfXxyPWPs=0gwFnWbAG5oLkrZ5jsO5Q_w1VOV1W2CPQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

________________________________________
From: Julian Calaby [julian.calaby@gmail.com]
Sent: Tuesday, July 24, 2012 9:07 AM
To: Mahesh Palivela
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; johannes@sipsolutions.net
Subject: Re: [PATCH v2] mac80211: VHT (11ac) Association

Hi Mahesh,

On Tue, Jul 24, 2012 at 1:33 PM, Mahesh Palivela <maheshp@posedge.com> wrote:
> VHT (11ac) Association related change version 2. Incorporated Johannes review comments.

The references to Johannes' review comments and version two shouldn't
go in the changelog, they should go below the "---" line after the
signoffs and stuff.

> Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

You can't just add a "Reviewed-by" line unless the person referenced
has explicitly said you can (or provided it themselves)

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

Thanks for the corrections Julian. I will not repeat next time.

Thanks,
Mahesh