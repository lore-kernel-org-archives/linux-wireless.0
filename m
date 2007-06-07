Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:40848 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751005AbXFGHMT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 03:12:19 -0400
Date: Thu, 7 Jun 2007 09:10:40 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFC: Regulatory info in mac80211
Message-ID: <20070607091040.2b2f1d00@morte>
In-Reply-To: <4665CCE7.5090409@lwfinger.net>
References: <4665CCE7.5090409@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 05 Jun 2007 15:51:51 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> 3. There should be some sort of checking to verify that the database has
> not been hacked to modify transmission power, etc. in an illegal manner.
> Obviously, no foolproof means of enforcing this does not exist; however,
> we should prevent the crudest form of modifications.

Why should this be enforced at all? What the Linux kernel has to do with
enforcing legality?

I see implementation of regulatory information in mac80211 as a convenient
way in order to avoid issues for the end user. Those issues includes:
1) violating the regulatory domain compliance without noticing;
2) losing time in order to get around domain compliance checks, when
this is done with perfect consciousness.


--
Ciao
Stefano
