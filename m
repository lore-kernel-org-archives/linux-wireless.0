Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43438 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427AbZJNOqw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 10:46:52 -0400
Date: Wed, 14 Oct 2009 10:33:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
Subject: Re: iwl3945: page allocation failure. order:5, mode:0x8020
Message-ID: <20091014143347.GD2890@tuxdriver.com>
References: <878wfenmmf.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <878wfenmmf.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 14, 2009 at 04:14:32PM +0300, Kalle Valo wrote:

> I didn't reboot during update, I only did 'modprobe -r iwl3945;
> modprobe iwl3945', so there's a small chance that something went wrong
> during update. But I still suspect something else is wrong because I
> have never seen this error before. 

This sounds a lot like the ongoing iwlagn allocation thread...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
