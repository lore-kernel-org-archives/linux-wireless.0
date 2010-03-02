Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:20279 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab0CBKB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 05:01:29 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: dsaxena@laptop.org
Subject: Re: [PATCH] libertas: add auto auth mode feature
Date: Tue, 2 Mar 2010 13:02:09 +0100
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
References: <1267146996-3725-1-git-send-email-bzhao@marvell.com> <1267225266.14995.7.camel@localhost.localdomain> <20100301195948.GA19200@plexity.net>
In-Reply-To: <20100301195948.GA19200@plexity.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003021302.10039.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> support is an option our community would be happy with. However, I also
> don't want to end up with a libertas fork (all our mesh patches are
> currently upstream and not forkd off)

Oh, sorry for being misinformed and spreading this misinformation. I had some 
read-only variables in the mainline libertas driver (for example  
mesh_autostart_enabled get's never written to) and heard that this is a 
remnant, and that the real implementation in in the OLPC tree.

Therefore I thought that you're sticking to some older kernel, and not 
following mainline linux at all.

Isn't that true?

-- 
http://www.holgerschurig.de
