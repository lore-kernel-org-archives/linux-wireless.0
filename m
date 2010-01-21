Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:38169 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab0AUUzD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 15:55:03 -0500
Date: Thu, 21 Jan 2010 12:51:38 -0800
From: Greg KH <greg@kroah.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [stable] [PATCH 2.6.{32, 31}] iwlwifi: power up all devices
 for EEPROM read
Message-ID: <20100121205138.GC14716@kroah.com>
References: <1264076545-12223-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1264076545-12223-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2010 at 01:22:25PM +0100, Stanislaw Gruszka wrote:
> commit f8701fe3aec24fcfb0dfa19aab47904611f96daf upstream
> 
> On 2.6.31 and 2.6.32 iwl3945 crash during kdump, I discovered
> above upstream commit fix that.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> I tested patch on 2.6.32 with iwl3945 - it fix kdump, and on 2.6.31
> with iwl5300 - no regression notice.

Thanks for the backport, I've queued this up now.

greg k-h
