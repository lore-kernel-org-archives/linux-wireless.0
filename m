Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23810 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaJ0GOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 02:14:34 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Joe Perches <joe@perches.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 07/11] iwlwifi: dvm: Fix probable mask then right shift
 defect
Date: Mon, 27 Oct 2014 06:14:29 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B556ABD@hasmsx107.ger.corp.intel.com> (sfid-20141027_071503_230142_DDFF00DC)
References: <cover.1414387334.git.joe@perches.com>
 <83c3bfdd0c8f21fbbcbd9ebb5746a8fb04494fac.1414387334.git.joe@perches.com>
In-Reply-To: <83c3bfdd0c8f21fbbcbd9ebb5746a8fb04494fac.1414387334.git.joe@perches.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Precedence of & and >> is not the same and is not left to right.
> shift has higher precedence and should be done after the mask.
> 
> Add parentheses around the mask.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Applied - thanks.
