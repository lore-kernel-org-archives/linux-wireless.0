Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:41612 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab1HXTNg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 15:13:36 -0400
Date: Wed, 24 Aug 2011 21:13:24 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [RFC][PATCH V2] b43: drop Kconfig option of forcing PIO mode
Message-ID: <20110824211324.6f5e36d0@milhouse> (sfid-20110824_211339_572489_31DA2EC4)
In-Reply-To: <20110824183128.GJ9770@tuxdriver.com>
References: <1313489647-8979-1-git-send-email-zajec5@gmail.com>
	<20110824183128.GJ9770@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 24 Aug 2011 14:31:28 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:
> > Larry introduced use_pio with:
> >     b43: Allow PIO mode to be selected at module load
> > I believe we can leave this simple module param and drop
> > CONFIG_B43_FORCE_PIO instead.
> 
> Seems reasonable to me...any objections?
> 

acked by me.

-- 
Greetings, Michael.
