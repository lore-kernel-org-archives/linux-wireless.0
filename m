Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49001 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbZGVMpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 08:45:55 -0400
Date: Wed, 22 Jul 2009 08:34:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
Subject: Re: wireless-testing regression: iwl3945 scan fails
Message-ID: <20090722123432.GA3927@tuxdriver.com>
References: <87k521s2wa.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <87k521s2wa.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 22, 2009 at 08:27:49AM +0300, Kalle Valo wrote:

> I just upgraded to rc3-wl (commit 225b6807) and my iwl3945 doesn't work
> anymore, even scan fails. I don't have time to investigate this right
> now, but I'll try to find some time during the evening.

Marcel had similar complaints yesterday evening.  I dunno which device
he has.  FWIW, the iwl5300 I have here seems to be working fine.

Maybe the Intel folks have some insight?  There was a big batch of
patches from them in yesterday's update.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
