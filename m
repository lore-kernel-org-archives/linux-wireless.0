Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:22065 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab1GLTgu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 15:36:50 -0400
Message-ID: <4E1CA251.6020305@gnu.org> (sfid-20110712_213653_753821_7EADCC26)
Date: Tue, 12 Jul 2011 15:36:49 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Sven Neumann <s.neumann@raumfeld.com>
CC: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: kernel NULL pointer dereference in lbs_set_11d_domain_info (3.0-rc6)
References: <1310399981.11331.4.camel@sven>  <4E1B655E.6010209@gnu.org>  <1310455326.2218.1.camel@sven> <4E1C6645.8060302@gnu.org> <1310489671.15321.2.camel@bender>
In-Reply-To: <1310489671.15321.2.camel@bender>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2011 12:54 PM, Sven Neumann wrote:
> That's what I did. The code crashes when trying to dereference the
> request parameter, which is NULL. I've already sent a patch that fixes
> this earlier today.

That's what I suspected.

-- 
Regards,
Pavel Roskin
