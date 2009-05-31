Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53865 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbZEaMuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 08:50:55 -0400
Date: Sun, 31 May 2009 09:36:34 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: alan-jenkins@tuffmail.co.uk,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090531123634.GA28630@khazad-dum.debian.net>
References: <1243524688.10632.0.camel@johannes.local> <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com> <1243763887.19302.29.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243763887.19302.29.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 31 May 2009, Johannes Berg wrote:
> You have a point there, but I'm not sure it even cares? When restarted

Yes, it does.  Some platforms retain state across shutdown, ThinkPads
included...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
