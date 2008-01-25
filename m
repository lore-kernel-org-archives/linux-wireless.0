Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbYAYCMp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 21:12:45 -0500
Subject: Re: does any wifi driver supports 802.11n for access point?
From: Dan Williams <dcbw@redhat.com>
To: hong zhang <henryzhang62@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48346.23149.qm@web57905.mail.re3.yahoo.com>
References: <48346.23149.qm@web57905.mail.re3.yahoo.com>
Content-Type: text/plain
Date: Thu, 24 Jan 2008 21:09:06 -0500
Message-Id: <1201226946.15917.12.camel@localhost.localdomain> (sfid-20080125_021255_917707_A62F5FE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-01-24 at 17:53 -0800, hong zhang wrote:
> List,
> 
> Could anyone please tell me which wifi driver supports
> 802.11n for access point?

None yet.  802.11n support is just being added to the mac80211 stack,
and driver support will follow.

Dan


