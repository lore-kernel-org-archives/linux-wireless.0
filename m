Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45959 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab1JGEom (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 00:44:42 -0400
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl12xx: remove sdio_test module
References: <1317933053.3549.66.camel@cumari>
	<1317933089-16128-1-git-send-email-coelho@ti.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 07 Oct 2011 07:44:41 +0300
In-Reply-To: <1317933089-16128-1-git-send-email-coelho@ti.com> (Luciano Coelho's message of "Thu\,  6 Oct 2011 23\:31\:29 +0300")
Message-ID: <87k48hh0li.fsf@purkki.adurom.net> (sfid-20111007_064446_143284_3ABE4EAB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <coelho@ti.com> writes:

> This module has been causing more trouble than being useful.  It only
> tests the SDIO speed by connecting to the wl12xx chip and does some
> throughput calculations.  It is an ugly quick hack and, if we really
> want to have it as part of wl12xx we need to clean it up and implement
> it properly.

IMHO just get rid of the thing. I'm sure you can count the users with
one hand so the maintenance effort is not worth it. Just put it to
wiki or somewhere else and anyone who needs it can apply (and fix) the
patch themselves.

-- 
Kalle Valo
