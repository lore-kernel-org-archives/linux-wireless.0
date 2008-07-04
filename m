Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57677 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881AbYGDUFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 16:05:19 -0400
Date: Fri, 4 Jul 2008 16:55:43 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Williams <dcbw@redhat.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: Question on rfkill double block
Message-ID: <20080704195543.GB27898@khazad-dum.debian.net> (sfid-20080704_220527_503207_4C2A32EF)
References: <1214982208.14590.473.camel@debian.sh.intel.com> <1215018189.29117.32.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1215018189.29117.32.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 02 Jul 2008, Dan Williams wrote:
> That would be more useful than the current enum, yes.

Dan, you do have a strong user case for "just software rfkilled", "just
hardware rfkilled" and "soft+hard rfkilled" as opposed to simply "software
rfkilled" and "hardware rfkilled, maybe software rfkilled as well" ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
