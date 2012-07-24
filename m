Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41348 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab2GXDiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 23:38:19 -0400
Received: by lbbgm6 with SMTP id gm6so8683486lbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 20:38:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC6FCB@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC6FCB@mbx022-e1-nj-10.exch022.domain.local>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 24 Jul 2012 13:37:57 +1000
Message-ID: <CAGRGNgVGfXxyPWPs=0gwFnWbAG5oLkrZ5jsO5Q_w1VOV1W2CPQ@mail.gmail.com> (sfid-20120724_053824_198903_B9A5A4B3)
Subject: Re: [PATCH v2] mac80211: VHT (11ac) Association
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
