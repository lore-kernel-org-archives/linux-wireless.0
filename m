Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:25210 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab1LVBdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 20:33:36 -0500
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Djalal Harouni <tixxdz@opendz.org>
CC: Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 21 Dec 2011 17:33:33 -0800
Subject: RE: [PATCH] drivers/iwlwifi: use dma_zalloc_coherent() for DMA
 allocation
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3501AC762882@orsmsx506.amr.corp.intel.com> (sfid-20111222_023341_751919_9214A917)
References: <20111221002147.GA4996@dztty>
 <1324486330.13074.322.camel@wwguy-huron> <20111221194852.GA19795@dztty>
In-Reply-To: <20111221194852.GA19795@dztty>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Djalal,

> 
> iwl-trans-pcie.c is one of the source files in iwlwifi driver hold 
> dual-license (GPL + BSD), are you ok to release your code for the BSD 
> license and relinquish the copyright?
Yes, It's ok.

Thank you very much

Wey
