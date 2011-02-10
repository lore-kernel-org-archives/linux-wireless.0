Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55577 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757240Ab1BJWYb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 17:24:31 -0500
Date: Thu, 10 Feb 2011 20:24:26 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jean RegisXFerraton <jean.regisx.ferraton@intel.com>,
	"marcel@holtmann.org" <marcel@holtmann.org>
Subject: Re: Advise on how to integrate latest bluetooth updates on linux
 2.6.35 kernel
Message-ID: <20110210222424.GA24388@khazad-dum.debian.net>
References: <6E42A1B4DD2F7B4D80A1F26BB498BF9F8C9F56AFD4@irsmsx501.ger.corp.intel.com>
 <456817.14949.qm@web161612.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <456817.14949.qm@web161612.mail.bf1.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 10 Feb 2011, Walter Goldens wrote:
> > I'm working in the bluetooth part in a project based on the
> > 2.6.35 linux kernel.
> > 
> > We've found some bugs related to bluetooth, and I've seen
> > that most of these bugs have been solved by latest releases
> > (2.6.36 and 2.6.37).

...

> Compat-wireless is your best bet. Noninvasive solution to your problem.

There is a 2.6.35 longterm, as well as stable 2.6.36.  If these are real
fixes that address bugs users will find on the field, they might well be
candidates for the stable (and longterm) releases.  And THAT is always much
preferable over compat-wireless, as it would be helpful to a lot more users.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
