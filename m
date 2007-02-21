Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42829
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422648AbXBUQiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 11:38:07 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/3] d80211: Split antenna selection into TX and RX antenna
Date: Wed, 21 Feb 2007 17:36:32 +0100
Cc: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702211702.46661.IvDoorn@gmail.com> <200702211712.54089.mb@bu3sch.de> <200702211727.55015.IvDoorn@gmail.com>
In-Reply-To: <200702211727.55015.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702211736.32461.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 February 2007 17:27, Ivo van Doorn wrote:
> -	int antenna_sel;
> +	int antenna_sel_tx;
> +	int antenna_sel_rx;

Hm, u8 here, too? The rest of this patch is ok.

-- 
Greetings Michael.
