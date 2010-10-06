Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44617 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759070Ab0JFRpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 13:45:05 -0400
Date: Wed, 6 Oct 2010 13:36:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/6] iwlwifi: schedule to deprecate software scan support
Message-ID: <20101006173609.GH2472@tuxdriver.com>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
 <1286378593-7509-2-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286378593-7509-2-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 06, 2010 at 08:23:08AM -0700, Wey-Yi Guy wrote:
> Hardware scan is the prefer method for all iwlwifi devices;
> especially for dual-mode functions. Schedule to deprecate the
> software scan support in kernel 2.6.40
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Hmmm...perhaps you have more confidence in this than I do?
My experience suggests that hardware scanning has been the source of
a number of problems and having the option to turn it off has provided
a useful workaround for any number of users.

Anyone else have heartburn over this one?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
