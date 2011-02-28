Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab1B1JYo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 04:24:44 -0500
Date: Mon, 28 Feb 2011 10:24:38 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] iwlwifi: fix dma mappings and skbs leak
Message-ID: <20110228092438.GB2230@redhat.com>
References: <1298649432-4416-1-git-send-email-sgruszka@redhat.com>
 <1298652464.28351.22.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1298652464.28351.22.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Fri, Feb 25, 2011 at 08:47:44AM -0800, Guy, Wey-Yi wrote:
> I don't think we need EXPORT_SYMBOL anymore after driver split

I will repost series addressing that and also comment from patch 3. 

Thanks
Stanislaw
