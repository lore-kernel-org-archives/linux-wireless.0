Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63698 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427Ab1FWDSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 23:18:42 -0400
Received: by iyb12 with SMTP id 12so1213857iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 20:18:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <237CF5B631AA3446BAC55A2F73815CEB01185DC6@nasanexd02b.na.qualcomm.com>
References: <1304594478.3749.61.camel@wimaxnb> <BANLkTimGs+hAX=5wE7PiTuVzD=4iLShBHQ@mail.gmail.com>
 <237CF5B631AA3446BAC55A2F73815CEB01185DC6@nasanexd02b.na.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Jun 2011 20:18:22 -0700
Message-ID: <BANLkTi=HVXDW_6GC5e03H7=OrbR2Hzf4uA@mail.gmail.com> (sfid-20110623_051855_153934_B6FF08AC)
Subject: Re: wireless-regdb US and CA settings incorrect?
To: "Green, Michael" <green@qca.qualcomm.com>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	"ext John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 22, 2011 at 5:18 PM, Green, Michael <green@qca.qualcomm.com> wrote:
> Well, the FCC & Canada regdomains should disable those TDWR channels for an AP.
> But regdomains for client devices should not disable those channels.
>
> In our licensed sw, we use different regdomains for AP vs. STA to accomplish this. Not sure how linux handles this.

In Linux, the DFS flag will prohibit initiating communication for AP,
IBSS, Mesh, or P2P in those frequency ranges as well.

  Luis
