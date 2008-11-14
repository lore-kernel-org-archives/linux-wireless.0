Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35819 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbYKNAQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 19:16:33 -0500
Date: Thu, 13 Nov 2008 22:16:24 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [GIT PATCH] rfkill fixes for 2.6.28-rc3
Message-ID: <20081114001624.GA10002@khazad-dum.debian.net> (sfid-20081114_011639_561251_7C362FEF)
References: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br> <200811031747.16326.IvDoorn@gmail.com> <20081103170243.GB2417@khazad-dum.debian.net> <200811031820.41165.IvDoorn@gmail.com> <20081112211530.GH2411@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081112211530.GH2411@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 12 Nov 2008, John W. Linville wrote:
> Still, I don't see how they qualify for 2.6.28.  How serious do you
> think this potential problem really is?

It is not very grave, but it IS annoying...  The only reason I don't
outright call it a regression, is that it was so broken before, it is just
broken in a different way without these patches.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
