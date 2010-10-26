Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36599 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758096Ab0JZOVn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 10:21:43 -0400
Subject: Re: [RFC] iwlwifi: Convert to new PCI PM framework
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1288037557-5197-1-git-send-email-linville@tuxdriver.com>
References: <1288037557-5197-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 26 Oct 2010 07:20:51 -0700
Message-Id: <1288102851.22425.6.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-25 at 13:12 -0700, John W. Linville wrote:
> Use the new PCI PM and let the PCI core code handle the PCI-specific
> details of power transitions.
> 
> Based on similarly titled ath9k patch posted by Rafael J. Wysocki.
> 
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---


