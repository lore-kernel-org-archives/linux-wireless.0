Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38211 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804AbZFJCoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 22:44:37 -0400
Date: Tue, 9 Jun 2009 23:44:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090610024437.GF593@khazad-dum.debian.net>
References: <1243928308.3192.38.camel@localhost.localdomain> <1243929706.20064.7.camel@johannes.local> <4A24E3E4.1050505@tuffmail.co.uk> <1243932109.3192.73.camel@localhost.localdomain> <20090603041030.GB10464@khazad-dum.debian.net> <1244034216.22679.22.camel@localhost.localdomain> <20090603214040.GD22809@khazad-dum.debian.net> <1244089486.4145.33.camel@localhost.localdomain> <20090607135456.GE3340@khazad-dum.debian.net> <1244388961.23850.93.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244388961.23850.93.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 07 Jun 2009, Marcel Holtmann wrote:
> > You can remove the EPO functionality and add a "switch all radios off"
> > and "switch all radios on" accell commands.  But that's all you can do
> > if you depend on userspace.  It will -not- be EPO.
> > 
> > You can have EPO in the kernel, and have userspace command the kernel to
> > enter and exit EPO state.
> 
> I fully disagree with you here and your concept of EPO and how it is
> suppose to work is fully flawed. EPO is a policy and if you define it as

Just rename it to something else.

Whether the current code can achieve what EPO is suposed to be is beside
the point.  Just rename that functionality to something else, as the
direction you want to go is clearly NOT one suitable for something named
"EPO".

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
