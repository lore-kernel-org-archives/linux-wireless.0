Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53029 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763262AbXGLBl2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 21:41:28 -0400
Subject: Re: [PATCH 1/1] iwl3945: provide frequency to radiotap monitor not  channel index
From: Zhu Yi <yi.zhu@intel.com>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070708201701.126477512@warmcat.com>
References: <20070708201636.804206271@warmcat.com>
	 <20070708201701.126477512@warmcat.com>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 09:40:48 +0800
Message-Id: <1184204448.13298.66.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-07-08 at 21:16 +0100, andy@warmcat.com wrote:
> iwl3945 and presumably 4965 wrongly provide the channel index to the
> radiotap
> header on Monitor mode.  This results in tcpdump showing "6MHz" for
> example.
> 
> This patch arranges to send the frequency in MHz instead eg, 2437MHz
> 
> Signed-off-by: Andy Green <andy@warmcat.com> 

Acked-by: Zhu Yi <yi.zhu@intel.com>
