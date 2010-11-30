Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2472 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab0K3Pjy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 10:39:54 -0500
Subject: Re: [PATCH w-t] iwlagn: fix microcode error on 4965
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101130143339.GC3074@redhat.com>
References: <20101130130148.GA3074@redhat.com>
	 <1291123016.3624.17.camel@jlt3.sipsolutions.net>
	 <20101130134903.GB3074@redhat.com>
	 <1291126178.3624.19.camel@jlt3.sipsolutions.net>
	 <20101130143339.GC3074@redhat.com>
Content-Type: text/plain
Date: Tue, 30 Nov 2010 07:38:50 -0800
Message-Id: <1291131530.13968.2.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-30 at 06:33 -0800, Stanislaw Gruszka wrote:
> Commit dbbf1755b09eef8ff6dd21c8dafe1606f051ce12 "iwlwifi: use
> antenna information in EEPROM" caused 4965 device breakage with
> "Microcode SW error detected.  Restarting 0x82000000." message.
> This patch reverts 4965 part of that commit.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---

Yeap, my mistake to cause this problem. Sorry!

Wey



