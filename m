Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab2BWKOL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 05:14:11 -0500
Date: Thu, 23 Feb 2012 11:14:08 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/4] iwlwifi: dump stack when fail to gain access to the
 device
Message-ID: <20120223101408.GA3386@redhat.com> (sfid-20120223_111417_359682_6D95DF1F)
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
 <20120210120101.GB2274@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120210120101.GB2274@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 10, 2012 at 01:01:01PM +0100, Stanislaw Gruszka wrote:
> I need to do a bit more testing before posting this. On iwlegacy the waring is
> triggered on rfkill, and currently I have no access to iwlwifi with rfkill
> switch, but seems there will be the same problem with iwlwifi: iwl_grab_nic_access()
> fail when rfkill is on.

Done, no problem notice with those patches and rfkill.

Stanislaw
