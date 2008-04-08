Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:33830 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYDHPNM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 11:13:12 -0400
Date: Tue, 8 Apr 2008 10:13:07 -0500
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: wimax@linuxwimax.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
Message-ID: <20080408101307.7b3717ed@speedy> (sfid-20080408_161550_864691_0932070A)
In-Reply-To: <200804011107.38563.inaky@linux.intel.com>
References: <200804011107.38563.inaky@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I notice that there is a binary supplicant required. After the experience with the
ipw3945 driver lack of acceptance, I would hope that Intel would have learned
that dependence on binary userspace components would limit acceptance especially
with other more hostile projects (OpenBSD).
