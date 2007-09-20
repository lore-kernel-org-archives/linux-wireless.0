Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbXITPx6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 11:53:58 -0400
Subject: Re: ath5k and network manager
From: Dan Williams <dcbw@redhat.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070919214007.1a6a9b4a@freepuppy.rosehill>
References: <20070919214007.1a6a9b4a@freepuppy.rosehill>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 11:51:53 -0400
Message-Id: <1190303513.2016.12.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-09-19 at 21:40 -0700, Stephen Hemminger wrote:
> Network manager doesn't seem to detect ath5k. Perhaps it is because
> it is name "ath0".  I think device should follow the convention of using
> name "wifi0" rather than BSD convention of putting driver name in device name.

NM shouldn't care what the device name is as long as the device has the
right tags in HAL and as long as the device doesn't get renamed
underneath NM (0.7 svn already uses device indexes internally instead).

Dan


