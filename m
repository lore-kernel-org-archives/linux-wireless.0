Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab0FIRxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 13:53:43 -0400
Subject: Re: iwlagn fails to assoc with nexus one in ad-hoc mode
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20100607.214612.26938385.davem@davemloft.net>
References: <20100607.214612.26938385.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 19:53:41 +0200
Message-ID: <1276106021.14580.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-07 at 21:46 -0700, David Miller wrote:
> When I try to associate 

FWIW, it is not actually associating, the TIM error in the log means
that it's actually setting up an IBSS network (yeah we should silence
the error as it's expected ...). Just in case somebody got confused if
the nexus was actually acting as an AP, it's not.

johannes

