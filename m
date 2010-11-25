Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab0KYMBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 07:01:05 -0500
Date: Thu, 25 Nov 2010 13:00:35 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: avoid "Error sending TX power (-5)"
Message-ID: <20101125120034.GA2442@redhat.com>
References: <1290595069-3878-1-git-send-email-sgruszka@redhat.com>
 <1290595452.3790.13.camel@jlt3.sipsolutions.net>
 <20101124130403.GA2446@redhat.com>
 <20101124141133.GA2983@redhat.com>
 <1290613280.28345.6.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1290613280.28345.6.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wed, Nov 24, 2010 at 07:41:20AM -0800, Guy, Wey-Yi wrote:
> > Not fully, message disappears at start, but not when module
> > is unloaded.
> > 
> you are correct, I miss that. Would you like to address that? or I can
> fix it

Please fix it, I could again do some crappy workaround instead
of proper fix.

Stanislaw
