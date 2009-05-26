Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48333 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZEZGli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 02:41:38 -0400
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Zhu Yi <yi.zhu@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>,
	Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20090526063602.GA21894@infradead.org>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
	 <1243307448-17441-2-git-send-email-yi.zhu@intel.com>
	 <1243312991.21383.3.camel@localhost.localdomain>
	 <1243317777.3623.19.camel@debian>
	 <1243319583.30938.2.camel@localhost.localdomain>
	 <20090526063602.GA21894@infradead.org>
Content-Type: text/plain
Date: Tue, 26 May 2009 08:41:10 +0200
Message-Id: <1243320070.30938.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christoph,

> > I think we need to fix this. Especially since all the other name length
> > limits in the driver model are gone.
> 
> Yeah, but at the same time the driver should get a shorter and actually
> pronouncable name.  Why not just iwl3200 to follow the model set by
> the other drivers?

that beast is a multi-comm device with WiFi, WiMAX, Bluetooth and GPS. I
think you can guess which pieces are coming next.

Regards

Marcel


