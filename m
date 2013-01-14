Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4895 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757441Ab3ANWgx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 17:36:53 -0500
Date: Mon, 14 Jan 2013 17:27:03 -0500
From: Pavel Roskin <proski@gnu.org>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k-devel@lists.ath9k.org dead ??  Fwd: Delivery Status
 Notification (Delay)
Message-ID: <20130114172703.12de8ed2@mj> (sfid-20130114_233658_106795_644C22C3)
In-Reply-To: <50F42EAC.40005@gmail.com>
References: <047d7b621b90b55bd304d341d180@google.com>
	<50F42EAC.40005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 14 Jan 2013 17:13:32 +0100
Xose Vazquez Perez <xose.vazquez@gmail.com> wrote:

> hi,
> 
> is ath9k-devel@lists.ath9k.org alive ?

It's dead most of the time.

There have been DNS problems with ath5k.org and ath9k.org for months.
Sometimes the DNS records are valid, but most of the time, they are not.

I informed Michael Renzmann about it.  He is the one who "maintains"
the lists.  He is also the maintainer of MadWifi.  He replied to me
that he knows about the problem.

I think we should remove ath5k and ath9k lists from the MAINTAINERS
file.

I believe most questions about ath5k and ath9k can be discussed in
linux-wireless.

Maybe a new list could be created to discuss all Atheros hardware on
Linux.  It could be used to make sure that Atheros/Qualcomm engineers
are aware of the topic.

-- 
Regards,
Pavel Roskin
