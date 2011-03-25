Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38771 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab1CYNUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 09:20:49 -0400
Date: Fri, 25 Mar 2011 09:19:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dennis Borgmann <dennis.borgmann@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Disabling ACKs with ath5k
Message-ID: <20110325131957.GA2242@tuxdriver.com>
References: <4D8C4764.7060107@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4D8C4764.7060107@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 25, 2011 at 08:42:28AM +0100, Dennis Borgmann wrote:

> Is there an interface to disable transmission of ACKs and on the other
> hand ignoring unreceived ACKs. It can be done with multicasting, but can
> it also be achieved by a setting with non-multicast-traffic? I am using
> ath5k.

I'm curious, why do you want to do that?

-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
