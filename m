Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab1ASHgk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 02:36:40 -0500
Date: Wed, 19 Jan 2011 08:36:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: stable@kernel.org, Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-wireless@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 2.6.32.y] hostap_cs: fix sleeping function called from
 invalid context
Message-ID: <20110119073629.GB2477@redhat.com>
References: <1295269524-4937-1-git-send-email-sgruszka@redhat.com>
 <4D35A87D.3020600@canonical.com>
 <20110118154305.GA2448@redhat.com>
 <4D3601BA.8040907@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D3601BA.8040907@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 18, 2011 at 02:10:18PM -0700, Tim Gardner wrote:
> I don't know either, but this device is becoming rare enough that
> I'm not gonna lose any sleep over it.

Ok, so defer any change since we see a bug report (I hope
we do not see, patch was tested by 2 users, it fix bug 
and device work for them).

Stanislaw
