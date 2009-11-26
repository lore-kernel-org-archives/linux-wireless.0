Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:50955 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503AbZKZHfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 02:35:18 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: PROPOSAL: cfg80211 antenna selection
Date: Thu, 26 Nov 2009 08:35:12 +0100
Cc: Bob Copeland <bcopeland@gmail.com>
References: <200911250941.10929.holgerschurig@gmail.com> <b6c5339f0911250637t1b698e94o9b835951ca8fbd60@mail.gmail.com>
In-Reply-To: <b6c5339f0911250637t1b698e94o9b835951ca8fbd60@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911260835.12818.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> So what does a mask of 0 mean?  No antennas, or use default?

Good question, default would be best.


But I actually like the rate idea from Luis, so we probably won't
use a bitmask then.

-- 
http://www.holgerschurig.de
