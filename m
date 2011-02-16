Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758796Ab1BPJR3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 04:17:29 -0500
Date: Wed, 16 Feb 2011 10:16:06 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Nathaniel Smith <njs@pobox.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: [PATCH 1/5] iwlwifi: Simplify tx queue management
Message-ID: <20110216091605.GA2812@redhat.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
 <1297619803-2832-2-git-send-email-njs@pobox.com>
 <1297677453.3785.4.camel@jlt3.sipsolutions.net>
 <AANLkTinA0yoF_dU+2B6+rHcE_DvS7yjqu+TqYzhprvZj@mail.gmail.com>
 <1297723541.4723.22.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297723541.4723.22.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 02:45:41PM -0800, wwguy wrote:
> btw, we are in the process of splitting 3945/4965 out of iwlwifi into it
> own directory (iwlwifilegacy). 
Uhh, we do not have suchlongdrivernames in kernel, what about iwlegacy :-)

Stanislaw

