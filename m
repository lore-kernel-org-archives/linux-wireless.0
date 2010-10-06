Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64802 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759083Ab0JFRw2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 13:52:28 -0400
Subject: Re: [PATCH 1/6] iwlwifi: schedule to deprecate software scan
 support
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20101006173609.GH2472@tuxdriver.com>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1286378593-7509-2-git-send-email-wey-yi.w.guy@intel.com>
	 <20101006173609.GH2472@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 06 Oct 2010 10:51:40 -0700
Message-Id: <1286387500.12594.24.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 10:36 -0700, John W. Linville wrote:
> On Wed, Oct 06, 2010 at 08:23:08AM -0700, Wey-Yi Guy wrote:
> > Hardware scan is the prefer method for all iwlwifi devices;
> > especially for dual-mode functions. Schedule to deprecate the
> > software scan support in kernel 2.6.40
> > 
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> Hmmm...perhaps you have more confidence in this than I do?
> My experience suggests that hardware scanning has been the source of
> a number of problems and having the option to turn it off has provided
> a useful workaround for any number of users.
> 
> Anyone else have heartburn over this one?
> 
The current HW scan implementation was improve a lot and sw scan will
cause problem, especially once we introduce P2P.

Wey

