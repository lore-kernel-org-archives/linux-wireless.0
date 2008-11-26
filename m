Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:9153 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYKZINw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 03:13:52 -0500
Received: by fg-out-1718.google.com with SMTP id 19so233925fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 00:13:50 -0800 (PST)
To: Harald Braumann <harry@unheit.net>
Subject: Re: [Ipw2100-devel] [PATCH] ipw2200: increase scan timeout
Date: Wed, 26 Nov 2008 09:13:26 +0100
Cc: linville@tuxdriver.com, ipw2100-devel@lists.sourceforge.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
References: <200811251809.55461.helmut.schaa@gmail.com> <20081125231735.5c9f7a50@sbs173>
In-Reply-To: <20081125231735.5c9f7a50@sbs173>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811260913.27267.helmut.schaa@gmail.com> (sfid-20081126_091414_440802_D9C7FDE4)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 25. November 2008 schrieb Harald Braumann:
> On Tue, 25 Nov 2008 18:09:54 +0100
> Helmut Schaa <helmut.schaa@googlemail.com> wrote:
> 
> > The current scan timeout is set to 5 seconds. If the timeout is hit
> > because the firmware did not respond yet, the adapter gets restarted,
> > which results in a disassociation.
> 
> Could this be a workaround for my bug as well (disconnects caused by
> scan while associated)?

No, seems to be something different :(

Helmut
