Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab1KUGir (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 01:38:47 -0500
Date: Mon, 21 Nov 2011 07:40:56 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 41/77] iwlegacy: s/STATUS_/S_/
Message-ID: <20111121064055.GA2217@redhat.com> (sfid-20111121_073850_390660_6D8892F9)
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
 <1321604559-10707-41-git-send-email-sgruszka@redhat.com>
 <20111118175828.6e94d02e@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111118175828.6e94d02e@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 05:58:28PM -0500, Pavel Roskin wrote:
> On Fri, 18 Nov 2011 09:22:03 +0100
> Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> I think this particular change would make the code less readable.  It's
> one thing to replace TABLE with TBL, but S_ can be anything - signed,
> special, settable, stable...
> 
> > -		set_bit(STATUS_RF_KILL_HW, &il->status);
> > +		set_bit(S_RF_KILL_HW, &il->status);
Should be obvious since we modify il->status

> You may want to replace RF_KILL with RFKILL if you are desperate to
> shorten variable names.
Good idea :-) 

Stanislaw
