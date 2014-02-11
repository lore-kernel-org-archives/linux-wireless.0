Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:33670 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaBKBcO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 20:32:14 -0500
Date: Tue, 11 Feb 2014 09:32:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	wil6210@qca.qualcomm.com, linux-pci@vger.kernel.org,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: Re: [PATCH] wil6210: Fix switch operator "missing break?" warning
Message-ID: <20140211013211.GA8173@localhost> (sfid-20140211_023219_978895_F20D229D)
References: <cover.1389904166.git.agordeev@redhat.com>
 <aedc9b7eb82232204a7d65b4c7d3302ba6ba3892.1389904167.git.agordeev@redhat.com>
 <20140207144639.GA10939@dhcp-26-207.brq.redhat.com>
 <3132701.EBRqRlvTI9@lx-vladimir>
 <20140210121638.GA320@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140210121638.GA320@dhcp-26-207.brq.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alexander,

On Mon, Feb 10, 2014 at 01:16:38PM +0100, Alexander Gordeev wrote:
> On Mon, Feb 10, 2014 at 12:54:13PM +0200, Vladimir Kondratiev wrote:
> > I can't reproduce this warning. What tools used to get it?
> 
> Fengguang?

This is a smatch warning:

        http://smatch.sourceforge.net/

Thanks,
Fengguang
