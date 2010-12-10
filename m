Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757094Ab0LJUbF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 15:31:05 -0500
Subject: Re: [PATCH 0/2] iwlwifi fix for 2.6.37
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20101210201750.GF4296@tuxdriver.com>
References: <1291918780-10882-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20101210201750.GF4296@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 10 Dec 2010 12:29:59 -0800
Message-Id: <1292012999.10280.184.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 12:17 -0800, John W. Linville wrote:
> On Thu, Dec 09, 2010 at 10:19:38AM -0800, Wey-Yi Guy wrote:
> > The original method used to parsing EEPROM Tx Power Table was hardcode and
> > not forward compatible with newer devices. Fix it here to be layout agnostic
> > 
> > John, we split EEPROM reading patches to two stage, for .37 release,
> > the existing devices will not change, only the newer devices will use
> > the new EEPROM reading method; we will remove the old EEPROM reading method
> > all together in separated patch for .38 release. Please let me know if this
> > is ok
> 
> OK, I think this will do.
> 
Thanks for taking it

Wey


