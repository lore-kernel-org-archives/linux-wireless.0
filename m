Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59976 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855AbYHCNcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 09:32:43 -0400
Date: Sun, 3 Aug 2008 10:32:38 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/8] rfkill: use the new WARN()
Message-ID: <20080803133238.GD12118@khazad-dum.debian.net> (sfid-20080803_153246_976077_A002CE81)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-7-git-send-email-hmh@hmh.eng.br> <200808031010.14048.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200808031010.14048.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 03 Aug 2008, Ivo van Doorn wrote:
> I rather see it merged into the other patch, backporting shouldn't really
> be kept in mind for development for the next kernel.
> The WARN() macro can easily be backported, and it doesn't make a real difference
> if this patch is provided seperately or merged with the pevious one.
> Both patches will end up in the same backport package anyway ;)

Very well, I will merge the two patches.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
