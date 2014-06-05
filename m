Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaFELws (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 07:52:48 -0400
Date: Thu, 5 Jun 2014 13:51:23 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	Matthias Fend <Matthias.Fend@wolfvision.net>
Subject: Re: [RFC/RFT 1/5] rt2x00: change beaconing locking
Message-ID: <20140605115122.GA1431@redhat.com> (sfid-20140605_135251_716870_3A0429FD)
References: <1401887955-11361-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401887955-11361-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 04, 2014 at 03:19:11PM +0200, Stanislaw Gruszka wrote:
> This patch is needed for further changes to keep global variables
> consisent when chaning beaconing on diffrent vif's.

I tested patches on IBSS an AP single and multi-bss mode. Beaconing
works, I will post official patches soon (with some changelog spell
fixes).

Stanislaw
