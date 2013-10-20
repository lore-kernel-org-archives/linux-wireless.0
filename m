Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:47473 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab3JTGBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Oct 2013 02:01:47 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iwlwifi: remove duplicate includes
Date: Sun, 20 Oct 2013 06:01:42 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DDAABA@HASMSX103.ger.corp.intel.com> (sfid-20131020_080234_966834_0169209D)
References: <1382245260-19065-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1382245260-19065-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Subject: [PATCH] iwlwifi: remove duplicate includes
> 
> Reported by "make includecheck"
> 
> Tested that the corresponding sources still compile well on x86
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-
> electrons.com>
> ---

Picked up. Thanks.
