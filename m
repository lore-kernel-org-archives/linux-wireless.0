Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:35553 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab0CLHKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 02:10:10 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: cfg80211 conversion of all drivers
Date: Fri, 12 Mar 2010 08:10:37 +0100
Cc: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	devel@linuxdriverproject.org,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <43e72e891003111722n4b4d5b6crf764dfe357ff8965@mail.gmail.com> <69e28c911003111756h224ef6a9x622c979232b6698b@mail.gmail.com> <20100312025330.GA15402@tuxdriver.com>
In-Reply-To: <20100312025330.GA15402@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003120810.38194.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I think that is code for "replace it with something based on mac80211"...

That's not going to happen, hostap + orinoco both work against fullmac chips, 
which can't send arbitrary packets and therefore no 802.11 management frames.

-- 
http://www.holgerschurig.de
