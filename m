Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab1BIRGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 12:06:39 -0500
Subject: Re: [PATCH 4/5] iwlwifi: fix ack health for WiFi/BT combo devices
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110209062645.GB2184@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
	 <1297153919-18766-4-git-send-email-sgruszka@redhat.com>
	 <1297179370.20613.30.camel@wwguy-ubuntu> <20110209062645.GB2184@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 09:04:53 -0800
Message-ID: <1297271093.20613.63.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-08 at 22:26 -0800, Stanislaw Gruszka wrote:
> On Tue, Feb 08, 2011 at 07:36:10AM -0800, wwguy wrote:
> > Hi Stanislaw,
> > 
> > On Tue, 2011-02-08 at 00:31 -0800, Stanislaw Gruszka wrote:
> > > Combo devices have TX statistics on different place, because
> > > struct statistics_rx_bt and struct statistics_rx have different
> > > size. User proper values on combo devices instead of random data.
> > > 
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>


It make sense, thanks
Wey


