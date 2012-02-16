Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab2BPLnv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 06:43:51 -0500
Date: Thu, 16 Feb 2012 12:43:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [iwlwifi 5000] Linux 3.3.0-rc2 drops wifi connection (regression
 from 3.2) - "No buffer space available"
Message-ID: <20120216114348.GC25833@redhat.com> (sfid-20120216_124354_765346_797D84B9)
References: <1328667237.1747.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1328667237.1747.26.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 08, 2012 at 02:13:57AM +0000, Maciej Marcin Piechotka wrote:
> Hello,
> 
> Linux 3.3.0 drops connections from WiFi on 3.3 (worked on 3.2).
> If I try to ping anything:
> 
> ping: sendmsg: No buffer space available
> 
> When I disable/enable WiFi by rfkill it works ok. I haven't found what
> determines the period before it happens.

What show dmesg?

Stanislaw
