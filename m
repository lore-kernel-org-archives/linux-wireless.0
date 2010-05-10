Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60963 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab0EJMRc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 08:17:32 -0400
Subject: Re: [ath9k-devel] [patch 2/9] ath9k: range checking issues in
 htc_hst.c
From: Pavel Roskin <proski@gnu.org>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Dan Carpenter <error27@gmail.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
In-Reply-To: <19431.58619.856626.694277@gargle.gargle.HOWL>
References: <20100508162201.GN27064@bicker>
	 <19431.36216.198492.247202@gargle.gargle.HOWL>
	 <20100510102319.GV27064@bicker>
	 <19431.58619.856626.694277@gargle.gargle.HOWL>
Content-Type: text/plain
Date: Mon, 10 May 2010 08:17:28 -0400
Message-Id: <1273493848.2783.3.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-10 at 16:20 +0530, Sujith wrote:

> Ah right. That should be fixed.

I suggest using ARRAY_SIZE(target->endpoint) to be sure.

-- 
Regards,
Pavel Roskin
