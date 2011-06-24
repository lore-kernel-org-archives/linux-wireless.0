Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64267 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab1FXOGH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 10:06:07 -0400
Subject: Re: [PATCH] iwlagn: fix rmmod crash
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1308908074-4163-1-git-send-email-sgruszka@redhat.com>
References: <1308908074-4163-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jun 2011 07:02:15 -0700
Message-ID: <1308924135.19001.1.camel@wwguy-ubuntu> (sfid-20110624_160612_101119_AEBBC91C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-24 at 02:34 -0700, Stanislaw Gruszka wrote:
> priv->bus.bus_specific pointer is used after priv structures was freed,
> in iwl_pci_remove(), what make ugly rmmod crash. This bug was introduced
> by current pci changes.
> 
> On the way remove fake check, if prober error code is returned from
> .probe() function, .remove() will never be called be null drvdata.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
you are right, thank you very much for catch this.

Wey

